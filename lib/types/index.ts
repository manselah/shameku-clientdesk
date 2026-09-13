export interface User {
  id: string
  email: string
  created_at: string
}

export interface Business {
  id: string
  user_id: string
  name: string
  description: string | null
  phone: string | null
  email: string | null
  address: string | null
  city: string | null
  state: string | null
  zip: string | null
  country: string | null
  website: string | null
  logo_url: string | null
  created_at: string
  updated_at: string
}

export interface Customer {
  id: string
  business_id: string
  name: string
  email: string | null
  phone: string | null
  address: string | null
  city: string | null
  state: string | null
  zip: string | null
  country: string | null
  created_at: string
  updated_at: string
}

export interface Product {
  id: string
  business_id: string
  name: string
  description: string | null
  price: number
  created_at: string
  updated_at: string
}

export interface Enquiry {
  id: string
  business_id: string
  customer_id: string
  subject: string
  message: string
  status: 'new' | 'contacted' | 'closed'
  created_at: string
  updated_at: string
}

export interface Order {
  id: string
  business_id: string
  customer_id: string
  order_number: string
  total_amount: number
  paid_amount: number
  outstanding_amount: number
  status: 'draft' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled'
  notes: string | null
  created_at: string
  updated_at: string
}

export interface OrderItem {
  id: string
  order_id: string
  product_id: string | null
  description: string
  quantity: number
  unit_price: number
  total_price: number
  created_at: string
}

export interface Payment {
  id: string
  business_id: string
  order_id: string
  amount: number
  payment_method: string
  reference: string | null
  notes: string | null
  created_at: string
}

export interface FollowUp {
  id: string
  business_id: string
  customer_id: string | null
  order_id: string | null
  title: string
  description: string | null
  due_date: string
  status: 'pending' | 'completed'
  created_at: string
  updated_at: string
}
