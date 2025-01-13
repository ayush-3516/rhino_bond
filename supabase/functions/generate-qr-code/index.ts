import { serve } from "https://deno.land/x/sift@0.6.0/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Initialize Supabase client
const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const supabase = createClient(supabaseUrl, supabaseKey);

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Only POST requests are allowed" }),
      { status: 405, headers: { "Content-Type": "application/json" } }
    );
  }

  try {
    const { productId, pointsValue, quantity, createdBy } = await req.json();

    // Validate inputs
    if (!productId || !pointsValue || !quantity || !createdBy) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Verify the product exists
    const { data: product, error: productError } = await supabase
      .from("products")
      .select("id, is_active")
      .eq("id", productId)
      .single();

    if (productError || !product || !product.is_active) {
      return new Response(
        JSON.stringify({ error: "Invalid or inactive product" }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    // Generate a unique batch ID
    const batchId = crypto.randomUUID();

    // Prepare QR code entries
    const qrCodes = Array.from({ length: quantity }).map(() => ({
      batch_id: batchId,
      product_id: productId,
      points_value: pointsValue,
      is_active: true,
      created_by: createdBy,
    }));

    // Insert QR codes into the database
    const { error: insertError } = await supabase.from("qr_codes").insert(qrCodes);

    if (insertError) {
      throw new Error("Error inserting QR codes: " + insertError.message);
    }

    return new Response(
      JSON.stringify({ message: "QR codes generated successfully", batchId }),
      { 
        status: 201, 
        headers: { 
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization"
        } 
      }
    );
  } catch (error) {
    console.error("Error generating QR codes:", error);
    return new Response(
      JSON.stringify({ error: "Failed to generate QR codes" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
