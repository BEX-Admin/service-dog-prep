-- Service Dog Prep - Supabase Schema
-- Run this entire script in the Supabase SQL Editor

create table if not exists public.dogs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  breed text,
  age int,
  size text,
  temperament text,
  fears text,
  goals text[],
  family_name text,
  contact text,
  habits text,
  health_notes text,
  preferred_training_times text,
  number_of_trainers int default 1,
  created_at timestamptz default now()
);

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid references public.dogs(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete cascade not null,
  date timestamptz default now(),
  behavior_scores jsonb,
  notes text,
  method_used text,
  opportunity_errors text[],
  created_at timestamptz default now()
);

alter table public.dogs enable row level security;
alter table public.sessions enable row level security;

create policy "Users can manage own dogs"
  on public.dogs for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can manage own sessions"
  on public.sessions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Additional columns for richer intake (run if tables already exist)
alter table public.dogs add column if not exists owner_email text;
alter table public.dogs add column if not exists owner_phone text;
alter table public.dogs add column if not exists address text;
alter table public.dogs add column if not exists training_path text;
alter table public.dogs add column if not exists notes text;
