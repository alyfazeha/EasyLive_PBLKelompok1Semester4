class Booking {
  final String title; // nama kost
  final String location; // alamat/lokasi kost
  final String price; // formatted, contoh: Rp 650.000

  /// UI pakai "Kost"/"Jasa".
  /// Untuk saat ini data dari table booking_kos => "Kost".
  final String type;

  /// UI pakai: "Active Now"/"Completed"/"Canceled".
  /// Di controller kita mapping dari status_pesanan.
  final String status;

  /// Tanggal check-in (dari booking_kos.tanggal_checkin)
  final String date;

  /// Status mentah dari supabase (optional, untuk kebutuhan detail page).
  final String? rawStatus;

  Booking({
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.status,
    required this.date,
    this.rawStatus,
  });
}
