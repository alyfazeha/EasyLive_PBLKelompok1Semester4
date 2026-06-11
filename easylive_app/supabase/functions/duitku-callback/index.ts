import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const API_KEY = "c20fb991c4e6c8fe3df137e2e87a3e2f";

async function verifySignature(
  merchantCode: string,
  amount: string,
  merchantOrderId: string,
  receivedSignature: string
): Promise<boolean> {
  const stringToSign = merchantCode + amount + merchantOrderId;
  console.log("stringToSign:", stringToSign);
  console.log("receivedSignature:", receivedSignature);

  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(API_KEY),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const buffer = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(stringToSign));
  const expectedSignature = Array.from(new Uint8Array(buffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");

  console.log("expectedSignature:", expectedSignature);
  console.log("match:", expectedSignature === receivedSignature);

  return expectedSignature === receivedSignature;
}

serve(async (req) => {
  try {
    // Log semua headers yang masuk untuk debug
    console.log("=== CALLBACK MASUK ===");
    console.log("Method:", req.method);
    console.log("URL:", req.url);

    // Cek content-type — kadang Duitku kirim JSON bukan form
    const contentType = req.headers.get("content-type") ?? "";
    console.log("Content-Type:", contentType);

    let merchantCode = "";
    let amount = "";
    let merchantOrderId = "";
    let reference = "";
    let resultCode = "";
    let receivedSig = "";

    if (contentType.includes("application/json")) {
      // Handle JSON format
      const json = await req.json();
      console.log("Body JSON:", JSON.stringify(json));
      merchantCode = json.merchantCode ?? "";
      amount = json.amount?.toString() ?? "";
      merchantOrderId = json.merchantOrderId ?? "";
      reference = json.reference ?? "";
      resultCode = json.resultCode ?? "";
      receivedSig = json.signature ?? "";
    } else {
      // Handle form-urlencoded format
      const body = await req.formData();
      merchantCode = body.get("merchantCode")?.toString() ?? "";
      amount = body.get("amount")?.toString() ?? "";
      merchantOrderId = body.get("merchantOrderId")?.toString() ?? "";
      reference = body.get("reference")?.toString() ?? "";
      resultCode = body.get("resultCode")?.toString() ?? "";
      receivedSig = body.get("signature")?.toString() ?? "";
      console.log("Body form:", { merchantCode, amount, merchantOrderId, reference, resultCode });
    }

    // SEMENTARA: skip verifikasi signature untuk debug
    // Aktifkan kembali setelah dipastikan callback masuk dengan benar
    const SKIP_SIG_VERIFY = true; // ganti false setelah production

    if (!SKIP_SIG_VERIFY) {
      const isValid = await verifySignature(merchantCode, amount, merchantOrderId, receivedSig);
      if (!isValid) {
        console.error("Signature tidak valid!");
        return new Response("Forbidden", { status: 403 });
      }
    } else {
      // Tetap log untuk monitoring
      await verifySignature(merchantCode, amount, merchantOrderId, receivedSig);
    }

    if (!reference) {
      console.error("Reference kosong, tidak bisa update");
      return new Response("Bad Request", { status: 400 });
    }

    let newPaymentStatus: string;
    let newBookingStatus: string;

    switch (resultCode) {
      case "00":
        newPaymentStatus = "settlement";
        newBookingStatus = "dikonfirmasi";
        break;
      case "02":
        newPaymentStatus = "cancel";
        newBookingStatus = "ditolak";
        break;
      default:
        newPaymentStatus = "pending";
        newBookingStatus = "menunggu";
    }

    console.log(`Update reference ${reference} → ${newPaymentStatus}`);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SERVICE_ROLE_KEY")!
    );

    const { data: payment, error: updatePaymentError } = await supabase
      .from("payments")
      .update({ status: newPaymentStatus })
      .eq("id_transaction", reference)
      .select("id_booking_kost, id_booking_jasa")
      .single();

    if (updatePaymentError) {
      console.error("Gagal update payments:", JSON.stringify(updatePaymentError));
      return new Response("Error", { status: 500 });
    }

    console.log("Update payments berhasil:", JSON.stringify(payment));

    if (payment?.id_booking_kost) {
      const { error: updateBookingError } = await supabase
        .from("booking_kos")
        .update({ status_pesanan: newBookingStatus })
        .eq("id_booking_kost", payment.id_booking_kost);

      if (updateBookingError) {
        console.error("Gagal update booking_kos:", JSON.stringify(updateBookingError));
      } else else if (payment?.id_booking_jasa) {
        // JALUR JASA (Sesuai dengan Check Constraint kamu: 'dikonfirmasi' / 'ditolak' / 'menunggu')
        const { error: updateJasaError } = await supabase
          .from("booking_jasa")
          .update({ status_pesanan: newBookingStatus })
          .eq("id_booking_jasa", payment.id_booking_jasa);

        if (updateJasaError) {
          console.error("Gagal update booking_jasa:", JSON.stringify(updateJasaError));
        } else {
          console.log("Update booking_jasa berhasil →", newBookingStatus);
        }
      } else {
        console.warn("Tidak ada id_booking_kost atau id_booking_jasa terkait payment ini");
      }
    }

    return new Response("OK", { status: 200 });
  } catch (e) {
    console.error("Callback error:", e);
    return new Response("Internal Server Error", { status: 500 });
  }
});