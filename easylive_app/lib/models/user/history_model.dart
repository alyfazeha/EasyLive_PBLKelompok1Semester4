class HistoryItem {
  final String id;
  final String type; // 'Kost' | 'Jasa'
  final String title;
  final String location;
  final String price;
  final String customerName;
  final String ownerName;
  final DateTime dateTime;
  final String status;
  /// ID numerik dari booking_kos atau booking_jasa, dipakai untuk query/insert review
  final int bookingId;

  const HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.price,
    required this.customerName,
    required this.ownerName,
    required this.dateTime,
    required this.status,
    required this.bookingId,
  });

  /// Factory dari row booking_kos JOIN kost JOIN profiles (customer) JOIN owner profiles
  factory HistoryItem.fromKostRow(Map<String, dynamic> row) {
    final kost = row['kost'] as Map<String, dynamic>? ?? {};
    final profile = row['profiles'] as Map<String, dynamic>? ?? {};
    final owner = kost['owner'] as Map<String, dynamic>? ?? {};
    final rawId = row['id_booking_kost'];

    return HistoryItem(
      id: 'kost-$rawId',
      type: 'Kost',
      bookingId: (rawId as num?)?.toInt() ?? 0,
      title: kost['nama_kost'] ?? '-',
      location: kost['alamat'] ?? '-',
      price: 'Rp ${_formatPrice(row['total_bayar'])}/bulan',
      customerName: profile['full_name'] ?? '-',
      ownerName: owner['full_name'] ?? '-',
      dateTime: DateTime.tryParse(row['tanggal_checkin'] ?? '') ?? DateTime.now(),
      status: row['status_pesanan'] ?? 'selesai',
    );
  }

  /// Factory dari row booking_jasa JOIN jasa JOIN profiles (customer) JOIN owner profiles
  factory HistoryItem.fromJasaRow(Map<String, dynamic> row) {
    final jasa = row['jasa'] as Map<String, dynamic>? ?? {};
    final profile = row['profiles'] as Map<String, dynamic>? ?? {};
    final owner = jasa['owner'] as Map<String, dynamic>? ?? {};
    final rawId = row['id_booking_jasa'];

    final tanggal = (row['tanggal'] as num?)?.toInt() ?? 1;
    final bulan = (row['bulan'] as num?)?.toInt() ?? 1;
    final dateTime = DateTime(DateTime.now().year, bulan, tanggal);

    return HistoryItem(
      id: 'jasa-$rawId',
      type: 'Jasa',
      bookingId: (rawId as num?)?.toInt() ?? 0,
      title: jasa['nama_jasa'] ?? '-',
      location: row['titik_penjemputan'] ?? '-',
      price: 'Rp ${_formatPrice(row['total_bayar'])}/order',
      customerName: profile['full_name'] ?? '-',
      ownerName: owner['full_name'] ?? '-',
      dateTime: dateTime,
      status: row['status_pesanan'] ?? 'selesai',
    );
  }

  static String _formatPrice(dynamic value) {
    if (value == null) return '0';
    final num = double.tryParse(value.toString()) ?? 0;
    return num
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }
}