class ApprovalModel {
  final String id; // Tambahkan ID untuk identifikasi unik
  final String name;
  final String propertyName;
  final String submittedDate;
  final String status;
  final String imageUrl;

  /// Persist dari Supabase kolom `alasan_tolak` (khusus kasus Rejected)
  final String? rejectionReason;

  ApprovalModel({
    required this.id, // Pastikan ID diisi saat membuat instance
    required this.name,
    required this.propertyName,
    required this.submittedDate,
    required this.status,
    required this.imageUrl,
    this.rejectionReason,
  });
}
