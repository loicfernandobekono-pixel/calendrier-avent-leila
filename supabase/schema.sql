-- À exécuter dans Supabase > SQL Editor
create table if not exists public.calendar_days (
  day integer primary key check (day between 1 and 24),
  title text not null default '',
  type text not null default 'letter',
  body text not null default '',
  media_url text not null default '',
  updated_at timestamptz not null default now()
);
alter table public.calendar_days enable row level security;
drop policy if exists "Public can read unlocked days" on public.calendar_days;
create policy "Public can read unlocked days" on public.calendar_days
for select to anon, authenticated
using (
  day <= case
    when (now() at time zone 'Europe/Paris')::date >= date '2026-12-01'
     and (now() at time zone 'Europe/Paris')::date <= date '2026-12-24'
    then extract(day from (now() at time zone 'Europe/Paris'))::int
    when (now() at time zone 'Europe/Paris')::date > date '2026-12-24' then 24
    else 0
  end
);
drop policy if exists "Authenticated admins can manage days" on public.calendar_days;
create policy "Authenticated admins can manage days" on public.calendar_days
for all to authenticated using (true) with check (true);

insert into storage.buckets (id,name,public)
values ('calendar-media','calendar-media',true)
on conflict (id) do update set public=true;
drop policy if exists "Public can view calendar media" on storage.objects;
create policy "Public can view calendar media" on storage.objects
for select to anon, authenticated using (bucket_id='calendar-media');
drop policy if exists "Authenticated users can upload calendar media" on storage.objects;
create policy "Authenticated users can upload calendar media" on storage.objects
for insert to authenticated with check (bucket_id='calendar-media');
drop policy if exists "Authenticated users can update calendar media" on storage.objects;
create policy "Authenticated users can update calendar media" on storage.objects
for update to authenticated using (bucket_id='calendar-media') with check (bucket_id='calendar-media');
