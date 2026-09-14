-- Enable required extensions
create extension if not exists "uuid-ossp";

-- Create auth schema if not exists (Supabase handles this, but ensure it's available)
-- The auth.users table is managed by Supabase

-- Create profiles table (synced with auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create businesses table
create table if not exists public.businesses (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'SHAMEKU',
  description text,
  phone text,
  email text,
  address text,
  city text,
  state text,
  zip text,
  country text,
  website text,
  logo_url text,
  currency text default 'USD',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id)
);

-- Create customers table
create table if not exists public.customers (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  name text not null,
  email text,
  phone text,
  address text,
  city text,
  state text,
  zip text,
  country text,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create products table
create table if not exists public.products (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  name text not null,
  description text,
  type text not null default 'product' check (type in ('product', 'service')),
  price numeric(12,2) not null check (price >= 0),
  active boolean default true,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create enquiries table
create table if not exists public.enquiries (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  customer_id uuid not null references public.customers(id) on delete cascade,
  subject text not null,
  message text not null,
  status text not null default 'new' check (status in ('new', 'contacted', 'closed')),
  source text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create orders table
create table if not exists public.orders (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  customer_id uuid not null references public.customers(id) on delete cascade,
  order_number text not null,
  total_amount numeric(12,2) not null default 0 check (total_amount >= 0),
  paid_amount numeric(12,2) not null default 0 check (paid_amount >= 0),
  outstanding_amount numeric(12,2) not null default 0 check (outstanding_amount >= 0),
  status text not null default 'draft' check (status in ('draft', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(business_id, order_number)
);

-- Create order_items table
create table if not exists public.order_items (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  description text not null,
  quantity numeric(10,2) not null check (quantity > 0),
  unit_price numeric(12,2) not null check (unit_price >= 0),
  total_price numeric(12,2) not null check (total_price >= 0),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create payments table
create table if not exists public.payments (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  order_id uuid not null references public.orders(id) on delete cascade,
  amount numeric(12,2) not null check (amount > 0),
  payment_method text not null check (payment_method in ('cash', 'bank_transfer', 'mobile_money', 'card', 'other')),
  reference text,
  notes text,
  paid_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create follow_ups table
create table if not exists public.follow_ups (
  id uuid primary key default uuid_generate_v4(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  customer_id uuid references public.customers(id) on delete set null,
  order_id uuid references public.orders(id) on delete set null,
  title text not null,
  description text,
  due_date timestamp with time zone not null,
  status text not null default 'pending' check (status in ('pending', 'completed')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create indexes for better query performance
create index if not exists idx_customers_business_id on public.customers(business_id);
create index if not exists idx_products_business_id on public.products(business_id);
create index if not exists idx_enquiries_business_id on public.enquiries(business_id);
create index if not exists idx_enquiries_customer_id on public.enquiries(customer_id);
create index if not exists idx_orders_business_id on public.orders(business_id);
create index if not exists idx_orders_customer_id on public.orders(customer_id);
create index if not exists idx_order_items_order_id on public.order_items(order_id);
create index if not exists idx_payments_business_id on public.payments(business_id);
create index if not exists idx_payments_order_id on public.payments(order_id);
create index if not exists idx_follow_ups_business_id on public.follow_ups(business_id);
create index if not exists idx_follow_ups_customer_id on public.follow_ups(customer_id);
create index if not exists idx_follow_ups_due_date on public.follow_ups(due_date);

-- Enable Row Level Security
alter table public.profiles enable row level security;
alter table public.businesses enable row level security;
alter table public.customers enable row level security;
alter table public.products enable row level security;
alter table public.enquiries enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.payments enable row level security;
alter table public.follow_ups enable row level security;

-- RLS Policies for profiles
create policy "Users can view their own profile" on public.profiles
  for select using (auth.uid() = id);

create policy "Users can update their own profile" on public.profiles
  for update using (auth.uid() = id);

-- RLS Policies for businesses
create policy "Users can view their own business" on public.businesses
  for select using (auth.uid() = user_id);

create policy "Users can insert their own business" on public.businesses
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own business" on public.businesses
  for update using (auth.uid() = user_id);

-- RLS Policies for customers (business-scoped)
create policy "Users can view customers in their business" on public.customers
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert customers in their business" on public.customers
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update customers in their business" on public.customers
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete customers in their business" on public.customers
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- RLS Policies for products
create policy "Users can view products in their business" on public.products
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert products in their business" on public.products
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update products in their business" on public.products
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete products in their business" on public.products
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- RLS Policies for enquiries
create policy "Users can view enquiries in their business" on public.enquiries
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert enquiries in their business" on public.enquiries
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update enquiries in their business" on public.enquiries
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete enquiries in their business" on public.enquiries
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- RLS Policies for orders
create policy "Users can view orders in their business" on public.orders
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert orders in their business" on public.orders
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update orders in their business" on public.orders
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete orders in their business" on public.orders
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- RLS Policies for order_items
create policy "Users can view order items in their business" on public.order_items
  for select using (
    order_id in (select id from public.orders where business_id in (select id from public.businesses where user_id = auth.uid()))
  );

create policy "Users can insert order items in their business" on public.order_items
  for insert with check (
    order_id in (select id from public.orders where business_id in (select id from public.businesses where user_id = auth.uid()))
  );

create policy "Users can update order items in their business" on public.order_items
  for update using (
    order_id in (select id from public.orders where business_id in (select id from public.businesses where user_id = auth.uid()))
  );

create policy "Users can delete order items in their business" on public.order_items
  for delete using (
    order_id in (select id from public.orders where business_id in (select id from public.businesses where user_id = auth.uid()))
  );

-- RLS Policies for payments
create policy "Users can view payments in their business" on public.payments
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert payments in their business" on public.payments
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update payments in their business" on public.payments
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete payments in their business" on public.payments
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- RLS Policies for follow_ups
create policy "Users can view follow ups in their business" on public.follow_ups
  for select using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can insert follow ups in their business" on public.follow_ups
  for insert with check (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can update follow ups in their business" on public.follow_ups
  for update using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

create policy "Users can delete follow ups in their business" on public.follow_ups
  for delete using (
    business_id in (select id from public.businesses where user_id = auth.uid())
  );

-- Trigger to sync auth.users to profiles on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do nothing;
  
  insert into public.businesses (user_id, name)
  values (new.id, 'SHAMEKU')
  on conflict (user_id) do nothing;
  
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
