import { z } from 'zod'

export const orderSchema = z.object({
  customer_id: z.string().min(1, 'Customer is required'),
  order_number: z.string().min(1, 'Order number is required'),
  status: z.enum(['draft', 'confirmed', 'shipped', 'delivered', 'cancelled']),
  notes: z.string().optional().or(z.literal('')),
})

export const orderItemSchema = z.object({
  description: z.string().min(1, 'Description is required'),
  quantity: z.coerce.number().min(0.01, 'Quantity must be greater than 0'),
  unit_price: z.coerce.number().min(0, 'Price must be 0 or greater'),
})

export type OrderInput = z.infer<typeof orderSchema>
export type OrderItemInput = z.infer<typeof orderItemSchema>
