import { createClient, SupabaseClient } from '@supabase/supabase-js'

// Server-only client — uses the service_role key to bypass RLS for writes
// (seeding universities/programs). NEVER import this from client components,
// and never expose SUPABASE_SERVICE_ROLE_KEY with a NEXT_PUBLIC_ prefix.
//
// Created lazily (not at module load) so a missing key only breaks the
// specific request that needs it, not the whole build.
let cached: SupabaseClient | null = null

export function getSupabaseAdmin(): SupabaseClient {
  if (cached) return cached

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error('SUPABASE_SERVICE_ROLE_KEY is not configured')
  }

  cached = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
  return cached
}
