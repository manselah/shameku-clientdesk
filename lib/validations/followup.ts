import { z } from 'zod'

export const followUpSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().optional().or(z.literal('')),
  customer_id: z.string().optional().or(z.literal('')),
  order_id: z.string().optional().or(z.literal('')),
  due_date: z.string().min(1, 'Due date is required'),
  status: z.enum(['pending', 'completed']),
})

export type FollowUpInput = z.infer<typeof followUpSchema>
