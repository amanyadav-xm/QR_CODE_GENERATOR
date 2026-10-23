-- Starter schema for the portfolio. Run in the Supabase SQL editor.
-- Create your admin user in Supabase Auth first. Tables are owner-scoped.
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text not null default '',
  details text not null default '',
  tech text[] not null default '{}',
  status text not null default 'In Progress' check (status in ('Planning','In Progress','Completed','Archived')),
  github text not null default '',
  demo text not null default '',
  image_path text,
  featured boolean not null default false,
  is_published boolean not null default false,
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.skills (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  category text not null default 'Programming',
  status text not null default 'Not Started' check (status in ('Not Started','Currently Learning','Practicing','Completed','On Hold')),
  progress integer not null default 0 check (progress between 0 and 100),
  target_date date,
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.learning_goals (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  status text not null default 'Not Started' check (status in ('Not Started','In Progress','Completed','On Hold')),
  due_date date,
  notes text not null default '',
  created_at timestamptz not null default now()
);
create table if not exists public.portfolio_settings (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'Aman Yadav',
  headline text not null default '',
  about text not null default '',
  github text not null default '',
  linkedin text not null default '',
  email text not null default '',
  education text not null default '',
  graduation_year text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.projects enable row level security;
alter table public.skills enable row level security;
alter table public.learning_goals enable row level security;
alter table public.portfolio_settings enable row level security;

-- Owner-only writes and reads. Public published-project reads can be added as a separate,
-- carefully scoped SELECT policy once the site queries published projects from Supabase.
create policy "Owners manage their projects" on public.projects for all to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Owners manage their skills" on public.skills for all to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Owners manage their learning goals" on public.learning_goals for all to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Owners manage their portfolio settings" on public.portfolio_settings for all to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

-- Storage policies are intentionally not created here because bucket access depends on your
-- public/private asset choice. Create a portfolio-assets bucket and add narrow policies.
