import { z } from 'zod'

export const followUpSchema = z.object({
  id: z.string().optional(),
  customer_id: z.string().min(1, 'Customer is required'),
  follow_up_date: z.string().min(1, 'Follow-up date is required'),
  reason: z.string().min(1, 'Reason is required'),
  status: z.enum(['pending', 'completed', 'cancelled']).default('pending'),
  notes: z.string().optional(),
  created_at: z.string().optional(),
  updated_at: z.string().optional(),
})

export type FollowUp = z.infer<typeof followUpSchema>
