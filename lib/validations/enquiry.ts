import { z } from 'zod'

export const enquirySchema = z.object({
  customer_id: z.string().min(1, 'Customer is required'),
  subject: z.string().min(1, 'Subject is required'),
  message: z.string().min(1, 'Message is required'),
  status: z.enum(['new', 'contacted', 'closed']),
  source: z.string().optional().or(z.literal('')),
})

export type EnquiryInput = z.infer<typeof enquirySchema>
