# Supabase Backend Functions Implementation Guide

This guide provides detailed instructions for implementing backend functions in the Rhino Bond project.

## Directory Structure

```
supabase/
├── functions/
│   ├── create-event/
│   ├── generate-qr-code/
│   ├── scan-qr-code/
│   ├── user-management/
│   ├── authentication/
│   ├── product-operations/
│   ├── transaction-operations/
│   └── event-operations/
```

## Required Dependencies

Add these to your `package.json`:

```json
{
  "dependencies": {
    "@supabase/supabase-js": "^2.0.0",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.3",
    "validator": "^13.7.0",
    "uuid": "^9.0.0"
  }
}
```

## Function Implementation Details

### 1. User Management Functions

#### create-update-profile.ts
```typescript
import { createClient } from '@supabase/supabase-js'

export default async (req: Request) => {
  const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_KEY!)
  
  // Validate input
  const { userId, profileData } = await req.json()
  
  // Upsert profile
  const { data, error } = await supabase
    .from('profiles')
    .upsert({
      id: userId,
      ...profileData
    })
    .select()
    
  return new Response(JSON.stringify(data || error))
}
```

### 2. Authentication Functions

#### verify-otp.ts
```typescript
import { createClient } from '@supabase/supabase-js'
import jwt from 'jsonwebtoken'

export default async (req: Request) => {
  const { phone, otp } = await req.json()
  
  // Verify OTP
  const { data, error } = await supabase
    .from('otp_verifications')
    .select('*')
    .eq('phone', phone)
    .eq('code', otp)
    .single()
    
  if (error) throw new Error('Invalid OTP')
  
  // Generate JWT
  const token = jwt.sign(
    { userId: data.user_id },
    process.env.JWT_SECRET!,
    { expiresIn: '1h' }
  )
  
  return new Response(JSON.stringify({ token }))
}
```

### 3. Product Operations

#### get-product-info.ts
```typescript
import { createClient } from '@supabase/supabase-js'

export default async (req: Request) => {
  const { productId } = await req.json()
  
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('id', productId)
    .single()
    
  return new Response(JSON.stringify(data || error))
}
```

### 4. Transaction Operations

#### process-redemption.ts
```typescript
import { createClient } from '@supabase/supabase-js'

export default async (req: Request) => {
  const { userId, productId, points } = await req.json()
  
  // Start transaction
  const { data, error } = await supabase.rpc('redeem_product', {
    user_id: userId,
    product_id: productId,
    points: points
  })
  
  return new Response(JSON.stringify(data || error))
}
```

### 5. QR Code Operations

#### validate-qr-code.ts
```typescript
import { createClient } from '@supabase/supabase-js'
import { validate as isUUID } from 'uuid'

export default async (req: Request) => {
  const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_KEY!)
  const { qrCodeId } = await req.json()

  // Validate UUID format
  if (!isUUID(qrCodeId)) {
    throw new Error('Invalid QR code format')
  }

  // Check QR code status
  const { data: qrCode, error } = await supabase
    .from('qr_codes')
    .select('*')
    .eq('id', qrCodeId)
    .single()

  if (error) throw new Error('QR code not found')
  if (qrCode.is_scanned) throw new Error('QR code already scanned')
  if (!qrCode.is_active) throw new Error('QR code is inactive')

  // Process QR code
  const result = await supabase.rpc('scan_qr_code', {
    qr_id: qrCodeId
  })

  if (result.error) throw new Error(result.error.message)

  return new Response(JSON.stringify({
    success: true,
    points: qrCode.points_value,
    product_id: qrCode.product_id
  }))
}
```

### 6. Event Operations

#### create-event.ts
```typescript
import { createClient } from '@supabase/supabase-js'
import { v4 as uuidv4 } from 'uuid'

export default async (req: Request) => {
  const { eventData } = await req.json()
  
  const { data, error } = await supabase
    .from('events')
    .insert({
      id: uuidv4(),
      ...eventData
    })
    .select()
    
  return new Response(JSON.stringify(data || error))
}
```

## Client-Side Operations to Move to Backend

The following operations should be implemented on the backend rather than client-side:

1. User Profile Management
   - createUserProfile()
   - updateUserProfile()
   - getUserProfile()
   
   Reasons:
   - Direct database access from client is insecure
   - Business logic should be centralized
   - Input validation should happen server-side
   - Audit logging should be implemented

2. Event Management
   - getActiveEvents()
   
   Reasons:
   - Event data should be filtered and validated server-side
   - Access control should be enforced
   - Caching can be implemented on backend

3. Authentication Operations
   - verifyPhoneNumber()
   - sendVerificationCode()
   
   Reasons:
   - Sensitive operations should be protected
   - Rate limiting should be enforced
   - Audit logging is critical

## Security Considerations

1. Validate all inputs
2. Use JWT for authentication
3. Implement rate limiting
4. Use environment variables for secrets
5. Enable row-level security in Supabase
6. Use database transactions for critical operations

## Testing Guidelines

1. Create test cases for each function
2. Test edge cases and error conditions
3. Use Supabase's local development environment
4. Implement automated tests using Jest
5. Test performance under load

## Deployment

1. Deploy functions using Supabase CLI:
```bash
supabase functions deploy
```

2. Set environment variables:
```bash
supabase secrets set SUPABASE_URL=your_url
supabase secrets set SUPABASE_KEY=your_key
```

3. Monitor function performance using Supabase dashboard
