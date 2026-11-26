-- Calendar settings for the Advent calendar
-- Run once in Supabase SQL Editor.
CREATE TABLE IF NOT EXISTS public.calendar_settings (
  key text PRIMARY KEY,
  value jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.calendar_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read calendar settings" ON public.calendar_settings;
CREATE POLICY "Public can read calendar settings"
ON public.calendar_settings FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Admins can manage calendar settings" ON public.calendar_settings;
CREATE POLICY "Admins can manage calendar settings"
ON public.calendar_settings FOR ALL
TO authenticated
USING ((auth.jwt()->'app_metadata'->>'role') = 'calendar_admin')
WITH CHECK ((auth.jwt()->'app_metadata'->>'role') = 'calendar_admin');

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON TABLE public.calendar_settings TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.calendar_settings TO authenticated;
