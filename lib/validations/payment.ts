import { z } from 'zod'

export const paymentSchema = z.object({
  order_id: z.string().min(1, 'Order is required'),
  amount: z.coerce.number().min(0.01, 'Amount must be greater than 0'),
  payment_method: z.enum(['cash', 'bank_transfer', 'mobile_money', 'card', 'other']),
  reference: z.string().optional().or(z.literal('')),
  notes: z.string().optional().or(z.literal('')),
})

export type PaymentInput = z.infer<typeof paymentSchema>
