import { z } from 'zod'

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
})

export const signupSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
})

export const customerSchema = z.object({
  name: z.string().min(1, 'Name is required').max(255),
  email: z.string().email().optional().or(z.literal('')),
  phone: z.string().optional().or(z.literal('')),
  address: z.string().optional().or(z.literal('')),
  city: z.string().optional().or(z.literal('')),
  state: z.string().optional().or(z.literal('')),
  zip: z.string().optional().or(z.literal('')),
  country: z.string().optional().or(z.literal('')),
  notes: z.string().optional().or(z.literal('')),
})

export const productSchema = z.object({
  name: z.string().min(1, 'Name is required').max(255),
  description: z.string().optional().or(z.literal('')),
  type: z.enum(['product', 'service']),
  price: z.string().or(z.number()).refine(
    (val) => {
      const num = typeof val === 'string' ? parseFloat(val) : val
      return !isNaN(num) && num >= 0
    },
    'Price must be a valid number'
  ),
  active: z.boolean().default(true),
})

export const enquirySchema = z.object({
  customer_id: z.string().uuid('Invalid customer'),
  subject: z.string().min(1, 'Subject is required').max(255),
  message: z.string().min(1, 'Message is required'),
  status: z.enum(['new', 'contacted', 'closed']).default('new'),
  source: z.string().optional().or(z.literal('')),
})

export const orderItemSchema = z.object({
  product_id: z.string().uuid().optional().or(z.literal('')),
  description: z.string().min(1, 'Description is required'),
  quantity: z.string().or(z.number()).refine(
    (val) => {
      const num = typeof val === 'string' ? parseFloat(val) : val
      return !isNaN(num) && num > 0
    },
    'Quantity must be greater than 0'
  ),
  unit_price: z.string().or(z.number()).refine(
    (val) => {
      const num = typeof val === 'string' ? parseFloat(val) : val
      return !isNaN(num) && num >= 0
    },
    'Price must be valid'
  ),
})

export const orderSchema = z.object({
  customer_id: z.string().uuid('Invalid customer'),
  order_number: z.string().min(1, 'Order number is required'),
  status: z.enum(['draft', 'confirmed', 'shipped', 'delivered', 'cancelled']).default('draft'),
  notes: z.string().optional().or(z.literal('')),
  items: z.array(orderItemSchema).min(1, 'Add at least one item'),
})

export const paymentSchema = z.object({
  order_id: z.string().uuid('Invalid order'),
  amount: z.string().or(z.number()).refine(
    (val) => {
      const num = typeof val === 'string' ? parseFloat(val) : val
      return !isNaN(num) && num > 0
    },
    'Amount must be greater than 0'
  ),
  payment_method: z.enum(['cash', 'bank_transfer', 'mobile_money', 'card', 'other']),
  reference: z.string().optional().or(z.literal('')),
  notes: z.string().optional().or(z.literal('')),
})

export const followUpSchema = z.object({
  customer_id: z.string().uuid().optional().or(z.literal('')),
  order_id: z.string().uuid().optional().or(z.literal('')),
  title: z.string().min(1, 'Title is required').max(255),
  description: z.string().optional().or(z.literal('')),
  due_date: z.string().min(1, 'Due date is required'),
  status: z.enum(['pending', 'completed']).default('pending'),
})

export const businessSchema = z.object({
  name: z.string().min(1, 'Business name is required').max(255),
  email: z.string().email().optional().or(z.literal('')),
  phone: z.string().optional().or(z.literal('')),
  address: z.string().optional().or(z.literal('')),
  city: z.string().optional().or(z.literal('')),
  state: z.string().optional().or(z.literal('')),
  zip: z.string().optional().or(z.literal('')),
  country: z.string().optional().or(z.literal('')),
  website: z.string().optional().or(z.literal('')),
  logo_url: z.string().optional().or(z.literal('')),
  description: z.string().optional().or(z.literal('')),
})

export type LoginInput = z.infer<typeof loginSchema>
export type SignupInput = z.infer<typeof signupSchema>
export type CustomerInput = z.infer<typeof customerSchema>
export type ProductInput = z.infer<typeof productSchema>
export type EnquiryInput = z.infer<typeof enquirySchema>
export type OrderInput = z.infer<typeof orderSchema>
export type PaymentInput = z.infer<typeof paymentSchema>
export type FollowUpInput = z.infer<typeof followUpSchema>
export type BusinessInput = z.infer<typeof businessSchema>
