

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."generate_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  user_id uuid := auth.uid();
begin
  insert into qr_codes (batch_id, product_id, points_value, created_by)
  values (batch_id, product_id, points_value, user_id);
end;
$$;


ALTER FUNCTION "public"."generate_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."insert_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer, "created_by" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  user_role text;
  is_service_role boolean;
begin
  -- Check if called by service role
  is_service_role := current_user = 'service_role';
  
  -- If not service role, verify admin permissions
  if not is_service_role then
    -- Get user role
    select role into user_role
    from users
    where id = created_by::uuid;

    -- Only allow admins to insert QR codes
    if user_role != 'admin' then
      raise exception 'Only admins can generate QR codes' using errcode = '42501';
    end if;
  end if;

  -- Insert the QR code
  insert into qr_codes (batch_id, product_id, points_value, created_by)
  values (batch_id, product_id, points_value, created_by);

  -- Return the inserted record
  return to_jsonb((
    select * from qr_codes
    where id = (select currval(pg_get_serial_sequence('qr_codes', 'id'))::bigint)
  ));
end;
$$;


ALTER FUNCTION "public"."insert_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer, "created_by" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redeem_product"("user_id" "uuid", "product_id" "uuid", "points" integer) RETURNS "json"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  user_points INTEGER;
  product_stock INTEGER;
BEGIN
  -- Validate user exists
  PERFORM 1 FROM public.users WHERE id = user_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'User not found'
      USING ERRCODE = 'P0004';
  END IF;

  -- Get user's current points
  SELECT points_balance INTO user_points
  FROM public.users
  WHERE id = user_id;

  -- Validate product exists
  PERFORM 1 FROM public.redemption_products WHERE id = product_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Product not found'
      USING ERRCODE = 'P0003';
  END IF;

  -- Get product's current stock
  SELECT stock INTO product_stock
  FROM public.redemption_products
  WHERE id = product_id;

  -- Validate points and stock
  IF user_points < points THEN
    RAISE EXCEPTION 'Insufficient points'
      USING ERRCODE = 'P0001';
  END IF;

  IF product_stock <= 0 THEN
    RAISE EXCEPTION 'Product out of stock'
      USING ERRCODE = 'P0002';
  END IF;

  -- Deduct points from user
  UPDATE public.users
  SET points_balance = points_balance - points
  WHERE id = user_id;

  -- Create transaction record
  INSERT INTO public.points_transactions (user_id, type, points, product_id)
  VALUES (user_id, 'redeem', points, product_id);

  -- Update product stock
  UPDATE public.redemption_products
  SET stock = stock - 1
  WHERE id = product_id;

  -- If we reach here, commit the transaction
  RETURN json_build_object('status', 'success', 'message', 'Product redeemed successfully');
EXCEPTION
  WHEN SQLSTATE 'P0001' THEN
    RETURN json_build_object('status', 'error', 'code', 'INSUFFICIENT_POINTS', 'message', 'User does not have enough points');
  WHEN SQLSTATE 'P0002' THEN
    RETURN json_build_object('status', 'error', 'code', 'OUT_OF_STOCK', 'message', 'Product is out of stock');
  WHEN SQLSTATE 'P0003' THEN
    RETURN json_build_object('status', 'error', 'code', 'PRODUCT_NOT_FOUND', 'message', 'Product does not exist');
  WHEN SQLSTATE 'P0004' THEN
    RETURN json_build_object('status', 'error', 'code', 'USER_NOT_FOUND', 'message', 'User does not exist');
  WHEN OTHERS THEN
    RETURN json_build_object('status', 'error', 'code', 'UNKNOWN_ERROR', 'message', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."redeem_product"("user_id" "uuid", "product_id" "uuid", "points" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."scan_qr_code"("qr_id" "uuid") RETURNS TABLE("success" boolean, "message" "text", "points_balance" integer, "debug_info" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    qr_record RECORD;
    user_record RECORD;
BEGIN
    -- Validate QR code exists
    SELECT * INTO qr_record 
    FROM qr_codes 
    WHERE id = qr_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 
            false AS success,
            'QR Code not found' AS message,
            NULL::INT AS points_balance,
            jsonb_build_object(
                'error', 'QR_CODE_NOT_FOUND',
                'qr_id', qr_id
            ) AS debug_info;
        RETURN;
    END IF;

    -- Validate QR code hasn't been scanned
    IF qr_record.is_scanned THEN
        RETURN QUERY SELECT 
            false AS success,
            'QR Code already scanned' AS message,
            NULL::INT AS points_balance,
            jsonb_build_object(
                'error', 'QR_CODE_ALREADY_SCANNED',
                'qr_id', qr_id,
                'scanned_at', qr_record.scanned_at
            ) AS debug_info;
        RETURN;
    END IF;

    -- Mark QR code as scanned
    UPDATE qr_codes
    SET 
        is_scanned = TRUE,
        scanned_at = NOW()
    WHERE id = qr_id;

    -- Update user points
    UPDATE users
    SET points_balance = points_balance + qr_record.points_value
    WHERE id = qr_record.user_id
    RETURNING * INTO user_record;

    -- Log transaction
    INSERT INTO points_transactions (
        user_id,
        type,
        points,
        qr_code_id,
        product_id,
        timestamp
    ) VALUES (
        qr_record.user_id,
        'earn',
        qr_record.points_value,
        qr_record.id,
        qr_record.product_id,
        NOW()
    );

    -- Return success response
    RETURN QUERY SELECT 
        true AS success,
        'QR Code scanned successfully' AS message,
        user_record.points_balance AS points_balance,
        jsonb_build_object(
            'qr_code', qr_record,
            'user', user_record
        ) AS debug_info;
END;
$$;


ALTER FUNCTION "public"."scan_qr_code"("qr_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."events" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "image_url" "text",
    "start_date" timestamp with time zone NOT NULL,
    "end_date" timestamp with time zone NOT NULL,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid"
);


ALTER TABLE "public"."events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."points_transactions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid",
    "type" "text" NOT NULL,
    "points" integer NOT NULL,
    "qr_code_id" "uuid",
    "product_id" "uuid",
    "timestamp" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "points_transactions_type_check" CHECK (("type" = ANY (ARRAY['earn'::"text", 'redeem'::"text"])))
);


ALTER TABLE "public"."points_transactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "points_value" integer NOT NULL,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."qr_codes" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "batch_id" "uuid" NOT NULL,
    "product_id" "uuid",
    "points_value" integer NOT NULL,
    "is_scanned" boolean DEFAULT false,
    "scanned_by" "uuid",
    "scanned_at" timestamp with time zone,
    "is_active" boolean DEFAULT true,
    "created_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "manual_identifier" "text" NOT NULL
);


ALTER TABLE "public"."qr_codes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."redemption_products" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "points_required" integer NOT NULL,
    "is_active" boolean DEFAULT true,
    "stock" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."redemption_products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "name" "text" NOT NULL,
    "email" "text" NOT NULL,
    "phone" "text",
    "pan_card" "text",
    "kyc_status" boolean DEFAULT false,
    "points_balance" integer DEFAULT 0,
    "role" "text" DEFAULT 'user'::"text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "admin_confirmation" boolean DEFAULT false,
    CONSTRAINT "users_role_check" CHECK (("role" = ANY (ARRAY['user'::"text", 'admin'::"text"])))
);


ALTER TABLE "public"."users" OWNER TO "postgres";


ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."points_transactions"
    ADD CONSTRAINT "points_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_manual_identifier_key" UNIQUE ("manual_identifier");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."redemption_products"
    ADD CONSTRAINT "redemption_products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "events_active_date_idx" ON "public"."events" USING "btree" ("is_active", "end_date");



ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."points_transactions"
    ADD CONSTRAINT "points_transactions_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."redemption_products"("id");



ALTER TABLE ONLY "public"."points_transactions"
    ADD CONSTRAINT "points_transactions_qr_code_id_fkey" FOREIGN KEY ("qr_code_id") REFERENCES "public"."qr_codes"("id");



ALTER TABLE ONLY "public"."points_transactions"
    ADD CONSTRAINT "points_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."qr_codes"
    ADD CONSTRAINT "qr_codes_scanned_by_fkey" FOREIGN KEY ("scanned_by") REFERENCES "public"."users"("id");



CREATE POLICY "Admin full access" ON "public"."qr_codes" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."role" = 'admin'::"text"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users"
  WHERE (("users"."id" = "auth"."uid"()) AND ("users"."role" = 'admin'::"text")))));



CREATE POLICY "Admins can insert/update users" ON "public"."users" FOR INSERT WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Admins can manage events" ON "public"."events" USING (("auth"."role"() = 'admin'::"text")) WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Admins can view all users" ON "public"."users" FOR SELECT USING (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Admins have full access" ON "public"."qr_codes" USING (("auth"."role"() = 'admin'::"text")) WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Allow inserts for service_role" ON "public"."qr_codes" FOR INSERT WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Creators can delete their events" ON "public"."events" FOR DELETE USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Creators can update their events" ON "public"."events" FOR UPDATE USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Only admins can create QR codes" ON "public"."qr_codes" FOR INSERT WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Only admins can modify products" ON "public"."products" FOR INSERT WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Only admins can modify redemption products" ON "public"."redemption_products" FOR INSERT WITH CHECK (("auth"."role"() = 'admin'::"text"));



CREATE POLICY "Products are publicly viewable" ON "public"."products" FOR SELECT USING (true);



CREATE POLICY "Public can view active events" ON "public"."events" FOR SELECT USING (("is_active" AND ("end_date" > "now"())));



CREATE POLICY "Redemption products are publicly viewable" ON "public"."redemption_products" FOR SELECT USING (true);



CREATE POLICY "Service role full access" ON "public"."qr_codes" TO "service_role" USING (true) WITH CHECK (true);



CREATE POLICY "User read access" ON "public"."qr_codes" FOR SELECT TO "authenticated" USING (("created_by" = "auth"."uid"()));



CREATE POLICY "Users can access their own data" ON "public"."users" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can insert their own QR codes" ON "public"."qr_codes" FOR INSERT WITH CHECK (("auth"."uid"() = "created_by"));



CREATE POLICY "Users can read their own QR codes" ON "public"."qr_codes" FOR SELECT USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Users can view own profile" ON "public"."users" FOR SELECT USING (("auth"."uid"() = "id"));



CREATE POLICY "Users can view own scanned QR codes" ON "public"."qr_codes" FOR SELECT USING ((("auth"."uid"() = "scanned_by") OR ("auth"."role"() = 'admin'::"text")));



CREATE POLICY "Users can view own transactions" ON "public"."points_transactions" FOR SELECT USING ((("auth"."uid"() = "user_id") OR ("auth"."role"() = 'admin'::"text")));



ALTER TABLE "public"."events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."points_transactions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."qr_codes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."redemption_products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."generate_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."generate_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."insert_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer, "created_by" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."insert_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer, "created_by" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."insert_qr_code"("batch_id" "uuid", "product_id" "uuid", "points_value" integer, "created_by" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."redeem_product"("user_id" "uuid", "product_id" "uuid", "points" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."redeem_product"("user_id" "uuid", "product_id" "uuid", "points" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."redeem_product"("user_id" "uuid", "product_id" "uuid", "points" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."scan_qr_code"("qr_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."scan_qr_code"("qr_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."scan_qr_code"("qr_id" "uuid") TO "service_role";


















GRANT ALL ON TABLE "public"."events" TO "anon";
GRANT ALL ON TABLE "public"."events" TO "authenticated";
GRANT ALL ON TABLE "public"."events" TO "service_role";



GRANT ALL ON TABLE "public"."points_transactions" TO "anon";
GRANT ALL ON TABLE "public"."points_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."points_transactions" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."qr_codes" TO "anon";
GRANT ALL ON TABLE "public"."qr_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."qr_codes" TO "service_role";



GRANT ALL ON TABLE "public"."redemption_products" TO "anon";
GRANT ALL ON TABLE "public"."redemption_products" TO "authenticated";
GRANT ALL ON TABLE "public"."redemption_products" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
