
-- SUPABASE DATABASE: APP QUẢN LÝ CÔNG TÁC ĐỘI
-- Chạy toàn bộ script này trong Supabase > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  role text not null default 'class' check (role in ('admin','class')),
  class_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.app_settings (
  id boolean primary key default true,
  school_name text not null default 'LIÊN ĐỘI TRƯỜNG THCS LƯƠNG THẾ VINH',
  current_week int not null default 4,
  pt int not null default 10,
  pk int not null default 5,
  ptb int not null default -15,
  py int not null default -30,
  updated_at timestamptz not null default now()
);

create table if not exists public.competition_scores (
  id uuid primary key default gen_random_uuid(),
  week int not null check (week between 1 and 52),
  class_name text not null,
  chuyen_can int not null default 0,
  ne_nep int not null default 0,
  van_nghe int not null default 0,
  xe_dap int not null default 0,
  ve_sinh int not null default 0,
  bon_hoa int not null default 0,
  tac_phong int not null default 0,
  t int not null default 0,
  k int not null default 0,
  tb int not null default 0,
  y int not null default 0,
  updated_at timestamptz not null default now(),
  unique(week, class_name)
);

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  ma_hs text,
  ho_ten text not null,
  lop text not null,
  gioi_tinh text,
  ngay_sinh text,
  la_doi_vien boolean not null default false,
  chuc_vu text,
  created_at timestamptz not null default now()
);

create table if not exists public.activities (
  id uuid primary key default gen_random_uuid(),
  ngay date not null default current_date,
  ten_hoat_dong text not null,
  doi_tuong text,
  ghi_chu text,
  created_at timestamptz not null default now()
);

create table if not exists public.violations (
  id uuid primary key default gen_random_uuid(),
  ngay date not null default current_date,
  ho_ten text not null,
  lop text not null,
  noi_dung text not null,
  diem int not null default -2,
  created_at timestamptz not null default now()
);

create table if not exists public.awards (
  id uuid primary key default gen_random_uuid(),
  ngay date not null default current_date,
  doi_tuong text not null,
  lop text,
  thanh_tich text not null,
  created_at timestamptz not null default now()
);

insert into public.app_settings(id) values(true) on conflict (id) do nothing;

alter table public.profiles enable row level security;
alter table public.app_settings enable row level security;
alter table public.competition_scores enable row level security;
alter table public.students enable row level security;
alter table public.activities enable row level security;
alter table public.violations enable row level security;
alter table public.awards enable row level security;

create or replace function public.my_role()
returns text language sql stable security definer set search_path = public
as $$ select role from public.profiles where id = auth.uid() $$;

create or replace function public.my_class()
returns text language sql stable security definer set search_path = public
as $$ select class_name from public.profiles where id = auth.uid() $$;

drop policy if exists "profiles own read" on public.profiles;
create policy "profiles own read" on public.profiles for select to authenticated
using (id = auth.uid() or public.my_role() = 'admin');

drop policy if exists "settings read" on public.app_settings;
create policy "settings read" on public.app_settings for select to authenticated using (true);
drop policy if exists "settings admin update" on public.app_settings;
create policy "settings admin update" on public.app_settings for all to authenticated
using (public.my_role()='admin') with check (public.my_role()='admin');

drop policy if exists "scores read" on public.competition_scores;
create policy "scores read" on public.competition_scores for select to authenticated
using (public.my_role()='admin' or class_name=public.my_class());
drop policy if exists "scores insert" on public.competition_scores;
create policy "scores insert" on public.competition_scores for insert to authenticated
with check (public.my_role()='admin' or class_name=public.my_class());
drop policy if exists "scores update" on public.competition_scores;
create policy "scores update" on public.competition_scores for update to authenticated
using (public.my_role()='admin' or class_name=public.my_class())
with check (public.my_role()='admin' or class_name=public.my_class());

drop policy if exists "students read" on public.students;
create policy "students read" on public.students for select to authenticated using (public.my_role()='admin' or lop=public.my_class());
drop policy if exists "students class write" on public.students;
create policy "students class write" on public.students for all to authenticated
using (public.my_role()='admin' or lop=public.my_class())
with check (public.my_role()='admin' or lop=public.my_class());

drop policy if exists "activities read" on public.activities;
create policy "activities read" on public.activities for select to authenticated using (true);
drop policy if exists "activities admin write" on public.activities;
create policy "activities admin write" on public.activities for all to authenticated
using (public.my_role()='admin') with check (public.my_role()='admin');

drop policy if exists "violations read" on public.violations;
create policy "violations read" on public.violations for select to authenticated using (public.my_role()='admin' or lop=public.my_class());
drop policy if exists "violations class write" on public.violations;
create policy "violations class write" on public.violations for all to authenticated
using (public.my_role()='admin' or lop=public.my_class())
with check (public.my_role()='admin' or lop=public.my_class());

drop policy if exists "awards read" on public.awards;
create policy "awards read" on public.awards for select to authenticated using (true);
drop policy if exists "awards admin write" on public.awards;
create policy "awards admin write" on public.awards for all to authenticated
using (public.my_role()='admin') with check (public.my_role()='admin');

-- 12 chi đội chuẩn:
-- 6A7, 6A8, 6A9, 7A7, 7A8, 7A9, 8A6, 8A7, 8A8, 9A8, 9A9, 9A10
