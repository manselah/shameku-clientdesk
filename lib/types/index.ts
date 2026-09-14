export type User = {
  id: string
  email: string
  created_at: string
  updated_at: string
}

export type Business = {
  id: string
  user_id: string
  name: string
  description?: string
  phone?: string
  email?: string
  address?: string
  city?: string
  state?: string
  zip?: string
  country?: string
  website?: string
  logo_url?: string
  currency: string
  created_at: string
  updated_at: string
}

export type Customer = {
  id: string
  business_id: string
  name: string
  email?: string
  phone?: string
  address?: string
  city?: string
  state?: string
  zip?: string
  country?: string
  notes?: string
  created_at: string
  updated_at: string
}

export type Product = {
  id: string
  business_id: string
  name: string
  description?: string
  type: 'product' | 'service'
  price: number
  active: boolean
  created_at: string
  updated_at: string
}

export type Enquiry = {
  id: string
  business_id: string
  customer_id: string
  subject: string
  message: string
  status: 'new' | 'contacted' | 'closed'
  source?: string
  created_at: string
  updated_at: string
}

export type Order = {
  id: string
  business_id: string
  customer_id: string
  order_number: string
  total_amount: number
  paid_amount: number
  outstanding_amount: number
  status: 'draft' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled'
  notes?: string
  created_at: string
  updated_at: string
}

export type OrderItem = {
  id: string
  order_id: string
  product_id?: string
  description: string
  quantity: number
  unit_price: number
  total_price: number
  created_at: string
}

export type Payment = {
  id: string
  business_id: string
  order_id: string
  amount: number
  payment_method: 'cash' | 'bank_transfer' | 'mobile_money' | 'card' | 'other'
  reference?: string
  notes?: string
  paid_at: string
  created_at: string
}

export type FollowUp = {
  id: string
  business_id: string
  customer_id?: string
  order_id?: string
  title: string
  description?: string
  due_date: string
  status: 'pending' | 'completed'
  created_at: string
  updated_at: string
}
