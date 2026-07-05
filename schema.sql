create table if not exists public.personal_dinner_invite_responses (
  id uuid primary key default gen_random_uuid(),
  invite_id text not null,
  response text not null check (response in ('yes', 'no', 'maybe')),
  created_at timestamptz not null default now(),
  user_agent text,
  page_url text
);

alter table public.personal_dinner_invite_responses enable row level security;

revoke all on table public.personal_dinner_invite_responses from anon, authenticated;
grant insert on table public.personal_dinner_invite_responses to anon;
grant insert on table public.personal_dinner_invite_responses to authenticated;

drop policy if exists "personal dinner invite public insert" on public.personal_dinner_invite_responses;
create policy "personal dinner invite public insert"
  on public.personal_dinner_invite_responses
  for insert
  to anon, authenticated
  with check (
    invite_id = 'dinner-2026-07'
    and response in ('yes', 'no', 'maybe')
  );

drop policy if exists "personal dinner invite no public select" on public.personal_dinner_invite_responses;
-- No SELECT policy: public visitors can insert responses, but cannot read them.
