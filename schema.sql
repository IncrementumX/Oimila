create table if not exists public.personal_dinner_invite_responses (
  id uuid primary key default gen_random_uuid(),
  invite_id text not null,
  response text not null check (response in ('oi', 'nada_a_ver', 'sim_jantar', 'recusou_jantar')),
  created_at timestamptz not null default now(),
  user_agent text,
  page_url text
);

alter table public.personal_dinner_invite_responses enable row level security;

revoke all on table public.personal_dinner_invite_responses from anon, authenticated;
grant insert, select on table public.personal_dinner_invite_responses to anon;
grant insert, select on table public.personal_dinner_invite_responses to authenticated;

drop policy if exists "personal dinner invite public insert" on public.personal_dinner_invite_responses;
create policy "personal dinner invite public insert"
  on public.personal_dinner_invite_responses
  for insert
  to anon, authenticated
  with check (
    invite_id = 'dinner-2026-07'
    and response in ('oi', 'nada_a_ver', 'sim_jantar', 'recusou_jantar')
  );

drop policy if exists "personal dinner invite scoped select" on public.personal_dinner_invite_responses;
-- Scoped SELECT: lets the in-page discreet viewer list responses for this one invite.
-- Note: the anon key is embedded in the page, so this makes responses for
-- invite_id = 'dinner-2026-07' publicly readable. Drop this policy to keep them
-- private and read them from the Supabase dashboard instead.
create policy "personal dinner invite scoped select"
  on public.personal_dinner_invite_responses
  for select
  to anon, authenticated
  using (
    invite_id = 'dinner-2026-07'
  );
