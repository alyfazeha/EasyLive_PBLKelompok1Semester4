class DetailBookingModel {
  final String idBooking;
  final String tenantName;
  final String phone;
  final String email;
  final String kosName;
  final String checkInDate;
  final String monthlyPrice;
  final String paymentStatus; // 'Lunas' atau 'Belum Lunas'
  final String bookingStatus; // 'Pending', 'Aktif', 'Ditolak', 'Selesai'
  final String alasanPenolakan;

  const DetailBookingModel({
    required this.idBooking,
    required this.tenantName,
    required this.phone,
    required this.email,
    required this.kosName,
    required this.checkInDate,
    required this.monthlyPrice,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.alasanPenolakan,
  });
}