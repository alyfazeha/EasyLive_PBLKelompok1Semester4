class DetailBookingJasaModel {
  final String idBooking;
  final String tenantName;
  final String phone;
  final String email;
  final String jasaName;
  final String titikPenjemputan;
  final String titikTujuan;
  final String totalBayar;
  final String paymentStatus;
  final String bookingStatus;
  final String alasanPenolakan;
  final String tanggal;

  const DetailBookingJasaModel({
    required this.idBooking,
    required this.tenantName,
    required this.phone,
    required this.email,
    required this.jasaName,
    required this.titikPenjemputan,
    required this.titikTujuan,
    required this.totalBayar,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.alasanPenolakan,
    required this.tanggal,
  });
}