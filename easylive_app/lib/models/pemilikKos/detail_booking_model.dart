class DetailBookingModel {
  final String tenantName;
  final String phone;
  final String email;
  final String kosName;
  final String roomName;
  final String checkInDate;
  final String monthlyPrice;
  final String paymentStatus;
  final String bookingStatus;

  const DetailBookingModel({
    required this.tenantName,
    required this.phone,
    required this.email,
    required this.kosName,
    required this.roomName,
    required this.checkInDate,
    required this.monthlyPrice,
    required this.paymentStatus,
    required this.bookingStatus,
  });
}
