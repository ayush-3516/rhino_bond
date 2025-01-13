CREATE OR REPLACE FUNCTION scan_qr_transaction(
  qr_code_id uuid,
  user_id uuid,
  points_value integer
) RETURNS json AS $$
DECLARE
  updated_user json;
BEGIN
  -- Begin transaction
  BEGIN
    -- Mark QR code as scanned
    UPDATE qr_codes
    SET 
      is_scanned = true,
      scanned_by = user_id,
      scanned_at = now()
    WHERE id = qr_code_id;

    -- Create points transaction
    INSERT INTO points_transactions (user_id, type, points, qr_code_id)
    VALUES (user_id, 'earn', points_value, qr_code_id);

    -- Update user's points balance
    UPDATE users
    SET points_balance = points_balance + points_value
    WHERE id = user_id
    RETURNING json_build_object(
      'id', id,
      'name', name,
      'points_balance', points_balance
    ) INTO updated_user;

    -- Commit transaction
    RETURN updated_user;
  EXCEPTION
    WHEN others THEN
      RAISE EXCEPTION 'Transaction failed: %', SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;
