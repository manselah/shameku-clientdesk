import { z } from 'zod'

export const productSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional().or(z.literal('')),
  type: z.enum(['product', 'service']),
  price: z.coerce.number().min(0, 'Price must be 0 or greater'),
  active: z.boolean().default(true),
})

export type ProductInput = z.infer<typeof productSchema>
