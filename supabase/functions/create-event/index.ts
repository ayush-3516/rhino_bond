// Import Supabase's Edge Runtime
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

// Setup function to create an event
Deno.serve(async (req) => {
  try {
    // Parse the incoming request
    const { title, description, image_url, start_date, end_date } = await req.json();

    // Validate required fields
    if (!title || !start_date || !end_date) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: title, start_date, or end_date" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get the Authorization header to validate admin user
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Unauthorized: Missing Authorization header" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    const jwt = authHeader.replace("Bearer ", "");
    const { role } = await getJwtPayload(jwt);

    // Ensure only admin users can access this function
    if (role !== "admin") {
      return new Response(
        JSON.stringify({ error: "Unauthorized: Only admin users can create events" }),
        { status: 403, headers: { "Content-Type": "application/json" } }
      );
    }

    // Insert the event into the Supabase database
    const supabaseClient = createClient();
    const { data, error } = await supabaseClient
      .from("events")
      .insert([
        {
          title,
          description,
          image_url: image_url || null,
          start_date,
          end_date,
          is_active: true,
        },
      ])
      .select();

    // Handle potential errors
    if (error) {
      console.error("Error inserting event:", error);
      return new Response(
        JSON.stringify({ error: error.message }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    // Return the created event
    return new Response(
      JSON.stringify({ data: data[0] }),
      { status: 201, headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Error handling request:", err);
    return new Response(
      JSON.stringify({ error: "Internal Server Error" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

/**
 * Simulate JWT payload extraction (for demonstration).
 * Replace this with your preferred JWT decoding library.
 */
async function getJwtPayload(jwt: string): Promise<{ role: string }> {
  // Decode and verify the JWT (implement actual verification in production)
  const payloadBase64 = jwt.split(".")[1];
  const payloadJson = atob(payloadBase64);
  const payload = JSON.parse(payloadJson);
  return { role: payload.role || "user" }; // Assume "user" role by default
}

/**
 * Create Supabase client for database operations.
 */
function createClient() {
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !supabaseKey) {
    throw new Error("Supabase URL or service role key is missing");
  }

  return new SupabaseClient(supabaseUrl, supabaseKey);
}
