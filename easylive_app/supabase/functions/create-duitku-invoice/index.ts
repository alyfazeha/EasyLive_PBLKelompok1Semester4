import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// =============================================
// KONFIGURASI - Ganti ke production saat live
// =============================================
const MERCHANT_CODE = Deno.env.get("DUITKU_MERCHANT_CODE")!;
const API_KEY = Deno.env.get("DUITKU_API_KEY")!;
const IS_SANDBOX = true; // ganti false untuk production

const DUITKU_BASE = IS_SANDBOX
  ? "https://api-sandbox.duitku.com"
  : "https://api-prod.duitku.com";

const DUITKU_URL = `${DUITKU_BASE}/api/merchant/createInvoice`;

// =============================================
// HELPER: Buat HMAC-SHA256 Signature
// =============================================
async function makeSignature(merchantCode: string, timestamp: string, apiKey: string): Promise<string> {
  const stringToSign = merchantCode + timestamp;
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(apiKey),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const buffer = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(stringToSign)
  );
  return Array.from(new Uint8Array(buffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// =============================================
// MAIN HANDLER
// =============================================
serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const {
      merchantOrderId,   // string unik per transaksi
      paymentAmount,     // integer, total bayar termasuk biaya layanan
      productDetails,    // nama kost
      customerName,      // nama dari form PersonalInfoView
      customerEmail,     // email user
      customerPhone,     // nomor HP dari form
      idBookingKost,     // id dari tabel booking_kos yang sudah diinsert
    } = await req.json();

    // Validasi input
    if (!merchantOrderId || !paymentAmount || !productDetails || !idBookingKost) {
      return new Response(
        JSON.stringify({ error: "Parameter tidak lengkap" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Buat timestamp & signature
    const timestamp = Date.now().toString();
    const signature = await makeSignature(MERCHANT_CODE, timestamp, API_KEY);

    // Body request ke Duitku
    const duitkuBody = {
      paymentAmount,
      merchantOrderId,
      productDetails,
      customerVaName: customerName ?? "Customer",
      email: customerEmail ?? "customer@email.com",
      phoneNumber: customerPhone ?? "",
      // callbackUrl: URL Edge Function duitku-callback kamu (harus public)
      callbackUrl: `${Deno.env.get("SUPABASE_URL")}/functions/v1/duitku-callback`,
      // returnUrl: deep link atau URL yang ditangkap WebView Flutter
      returnUrl: "https://ngekost.app/payment/return",
      expiryPeriod: 60, // 60 menit
      // Kosongkan paymentMethod agar user bisa pilih semua metode
      // Atau isi "SP" untuk langsung QRIS ShopeePay
      paymentMethod: "",
      itemDetails: [
        {
          name: productDetails,
          price: paymentAmount,
          quantity: 1,
        },
      ],
      customerDetail: {
        firstName: customerName?.split(" ")[0] ?? "Customer",
        lastName: customerName?.split(" ").slice(1).join(" ") ?? "",
        email: customerEmail ?? "customer@email.com",
        phoneNumber: customerPhone ?? "",
      },
    };

    // Hit API Duitku
    const duitkuRes = await fetch(DUITKU_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-duitku-timestamp": timestamp,
        "x-duitku-signature": signature,
        "x-duitku-merchantcode": MERCHANT_CODE,
      },
      body: JSON.stringify(duitkuBody),
    });

    const duitkuData = await duitkuRes.json();

    if (duitkuData.statusCode !== "00") {
      console.error("Duitku error:", duitkuData);
      return new Response(
        JSON.stringify({ error: duitkuData.statusMessage ?? "Gagal membuat invoice" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Simpan ke tabel payments di Supabase
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SERVICE_ROLE_KEY")!
    );

    const { error: insertError } = await supabase.from("payments").insert({
      id_transaction: duitkuData.reference,
      id_booking_kost: idBookingKost,
      payment_type: "QRIS",
      gross_amount: paymentAmount,
      snap_token: duitkuData.reference, // pakai reference sebagai token
      status: "pending",
    });

    if (insertError) {
      console.error("Supabase insert error:", insertError);
      // Tetap return paymentUrl meski insert gagal, agar user bisa bayar
    }

    return new Response(
      JSON.stringify({
        reference: duitkuData.reference,
        paymentUrl: duitkuData.paymentUrl,
        statusCode: duitkuData.statusCode,
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  } catch (e) {
    console.error("Unexpected error:", e);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});