-- Calendrier de l'Avent « 24 jours plus près de toi »
-- À exécuter une seule fois dans Supabase > SQL Editor.
-- Le bucket est public pour permettre l'affichage des médias sur GitHub Pages.
-- Seuls les comptes dont app_metadata.role = 'calendar_admin' peuvent modifier le contenu ou téléverser/supprimer des médias.

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
create policy "Public can read unlocked days"
on public.calendar_days
for select
to anon, authenticated
using (
  day <= case
    when (now() at time zone 'Europe/Paris')::date >= date '2026-12-01'
     and (now() at time zone 'Europe/Paris')::date <= date '2026-12-24'
    then extract(day from (now() at time zone 'Europe/Paris'))::integer
    when (now() at time zone 'Europe/Paris')::date > date '2026-12-24' then 24
    else 0
  end
);

drop policy if exists "Authenticated admins can manage days" on public.calendar_days;
create policy "Authenticated admins can manage days"
on public.calendar_days
for all
to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin')
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin');

-- Bucket public : les médias sont lisibles via URL publique.
insert into storage.buckets (id, name, public)
values ('calendar-media', 'calendar-media', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view calendar media" on storage.objects;
create policy "Public can view calendar media"
on storage.objects
for select
to anon, authenticated
using (bucket_id = 'calendar-media');

drop policy if exists "Calendar admins can upload media" on storage.objects;
create policy "Calendar admins can upload media"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'calendar-media'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin'
);

drop policy if exists "Calendar admins can update media" on storage.objects;
create policy "Calendar admins can update media"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'calendar-media'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin'
)
with check (
  bucket_id = 'calendar-media'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin'
);

drop policy if exists "Calendar admins can delete media" on storage.objects;
create policy "Calendar admins can delete media"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'calendar-media'
  and (auth.jwt() -> 'app_metadata' ->> 'role') = 'calendar_admin'
);
