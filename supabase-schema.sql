-- MultiPost Extension Supabase Schema
-- 请在 Supabase SQL Editor 中执行此脚本

-- 1. 启用 UUID 扩展（如果还没有启用）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. 创建用户配置表
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 创建用户平台账号表（存储各个平台的账号信息）
CREATE TABLE IF NOT EXISTS public.user_platform_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    platform_key TEXT NOT NULL,
    platform_name TEXT NOT NULL,
    account_id TEXT NOT NULL,
    username TEXT,
    avatar_url TEXT,
    profile_url TEXT,
    extra_data JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, platform_key)
);

-- 4. 创建发布历史表
CREATE TABLE IF NOT EXISTS public.publish_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content_type TEXT NOT NULL, -- 'DYNAMIC', 'ARTICLE', 'VIDEO', 'PODCAST'
    title TEXT,
    content TEXT,
    platforms JSONB NOT NULL, -- 发布的平台列表
    status TEXT DEFAULT 'pending', -- 'pending', 'success', 'failed', 'partial'
    result JSONB, -- 每个平台的发布结果
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- 5. 创建 API Key 表（用于 RESTful API 调用）
CREATE TABLE IF NOT EXISTS public.api_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    key TEXT UNIQUE NOT NULL,
    name TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    last_used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- 6. 创建索引以优化查询性能
CREATE INDEX IF NOT EXISTS idx_user_platform_accounts_user_id ON public.user_platform_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_user_platform_accounts_platform_key ON public.user_platform_accounts(platform_key);
CREATE INDEX IF NOT EXISTS idx_publish_history_user_id ON public.publish_history(user_id);
CREATE INDEX IF NOT EXISTS idx_publish_history_created_at ON public.publish_history(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_keys_user_id ON public.api_keys(user_id);
CREATE INDEX IF NOT EXISTS idx_api_keys_key ON public.api_keys(key) WHERE is_active = true;

-- 7. 启用 Row Level Security (RLS)
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_platform_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.publish_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.api_keys ENABLE ROW LEVEL SECURITY;

-- 8. 创建 RLS 策略

-- user_profiles 策略
CREATE POLICY "Users can view their own profile"
    ON public.user_profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
    ON public.user_profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
    ON public.user_profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- user_platform_accounts 策略
CREATE POLICY "Users can view their own platform accounts"
    ON public.user_platform_accounts FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own platform accounts"
    ON public.user_platform_accounts FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own platform accounts"
    ON public.user_platform_accounts FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own platform accounts"
    ON public.user_platform_accounts FOR DELETE
    USING (auth.uid() = user_id);

-- publish_history 策略
CREATE POLICY "Users can view their own publish history"
    ON public.publish_history FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own publish history"
    ON public.publish_history FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- api_keys 策略
CREATE POLICY "Users can view their own API keys"
    ON public.api_keys FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own API keys"
    ON public.api_keys FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own API keys"
    ON public.api_keys FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own API keys"
    ON public.api_keys FOR DELETE
    USING (auth.uid() = user_id);

-- 9. 创建触发器函数：自动更新 updated_at 字段
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10. 为需要的表添加触发器
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_platform_accounts_updated_at
    BEFORE UPDATE ON public.user_platform_accounts
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- 11. 创建触发器：用户注册后自动创建 profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_profiles (id, username, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
        NEW.raw_user_meta_data->>'avatar_url'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- 12. 创建视图：用户统计信息
CREATE OR REPLACE VIEW public.user_stats AS
SELECT 
    u.id as user_id,
    u.email,
    up.username,
    COUNT(DISTINCT upa.id) as connected_platforms,
    COUNT(DISTINCT CASE WHEN ph.status = 'success' THEN ph.id END) as successful_publishes,
    COUNT(DISTINCT ph.id) as total_publishes,
    MAX(ph.created_at) as last_publish_at
FROM auth.users u
LEFT JOIN public.user_profiles up ON u.id = up.id
LEFT JOIN public.user_platform_accounts upa ON u.id = upa.user_id AND upa.is_active = true
LEFT JOIN public.publish_history ph ON u.id = ph.user_id
GROUP BY u.id, u.email, up.username;

-- 完成！数据库架构创建成功
-- 现在可以在 Supabase 管理界面中：
-- 1. 进入 Authentication > Email Templates 配置邮件模板
-- 2. 进入 Settings > API 查看和管理 API Keys
-- 3. 测试用户注册和登录功能
