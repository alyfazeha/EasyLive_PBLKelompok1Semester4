import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const API_KEY = Deno.env.get("DUITKU_API_KEY")!;
const MERCHANT_CODE = Deno.env.get("DUITKU_MERCHANT_CODE")!;

// =============================================
// HELPER: Verifikasi Signature dari Duitku
// =============================================
async function verifySignature(
  merchantCode: string,
  amount: string,
  merchantOrderId: string,
  receivedSignature: string
): Promise<boolean> {
  const stringToSign = merchantCode + amount + merchantOrderId;
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(API_KEY),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const buffer = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(stringToSign)
  );
  const expectedSignature = Array.from(new Uint8Array(buffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");

  return expectedSignature === receivedSignature;
}

// =============================================
// MAIN HANDLER
// =============================================
serve(async (req) => {
  try {
    // Duitku kirim callback sebagai x-www-form-urlencoded
    const body = await req.formData();

    const merchantCode   = body.get("merchantCode")?.toString() ?? "";
    const amount         = body.get("amount")?.toString() ?? "";
    const merchantOrderId = body.get("merchantOrderId")?.toString() ?? "";
    const reference      = body.get("reference")?.toString() ?? "";
    const resultCode     = body.get("resultCode")?.toString() ?? "";
    const receivedSig    = body.get("signature")?.toString() ?? "";

    console.log("Callback diterima:", { merchantOrderId, reference, resultCode });

    // Verifikasi signature keamanan
    const isValid = await verifySignature(merchantCode, amount, merchantOrderId, receivedSig);
    if (!isValid) {
      console.error("Signature tidak valid!");
      return new Response("Forbidden", { status: 403 });
    }

    // Map resultCode ke status tabel payments
    let newPaymentStatus: string;
    let newBookingStatus: string;

    switch (resultCode) {
      case "00": // Success
        newPaymentStatus = "settlement";
        newBookingStatus = "dikonfirmasi";
        break;
      case "02": // Failed/Canceled
        newPaymentStatus = "cancel";
        newBookingStatus = "ditolak";
        break;
      default: // Pending
        newPaymentStatus = "pending";
        newBookingStatus = "menunggu";
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SERVICE_ROLE_KEY")!
    );

    // Update status di tabel payments
    const { data: payment, error: updatePaymentError } = await supabase
      .from("payments")
      .update({ status: newPaymentStatus })
      .eq("id_transaction", reference)
      .select("id_booking_kost")
      .single();

    if (updatePaymentError) {
      console.error("Gagal update payments:", updatePaymentError);
      return new Response("Error", { status: 500 });
    }

    // Update status di tabel booking_kos
    if (payment?.id_booking_kost) {
      const { error: updateBookingError } = await supabase
        .from("booking_kos")
        .update({ status_pesanan: newBookingStatus })
        .eq("id_booking_kost", payment.id_booking_kost);

      if (updateBookingError) {
        console.error("Gagal update booking_kos:", updateBookingError);
      }
    }

    console.log(`Transaksi ${reference} diupdate ke: ${newPaymentStatus}`);

    // Duitku butuh response HTTP 200 OK
    return new Response("OK", { status: 200 });
  } catch (e) {
    console.error("Callback error:", e);
    return new Response("Internal Server Error", { status: 500 });
  }
});