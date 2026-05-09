class DetailBookingModel {
  final String tenantName;
  final String phone;
  final String email;
  final String jasaName;
  final String kendaraanName;
  final String checkInDate;
  final String monthlyPrice;
  final String paymentStatus;
  final String bookingStatus;

  const DetailBookingModel({
    required this.tenantName,
    required this.phone,
    required this.email,
    required this.jasaName,
    required this.kendaraanName,
    required this.checkInDate,
    required this.monthlyPrice,
    required this.paymentStatus,
    required this.bookingStatus,
  });
}

