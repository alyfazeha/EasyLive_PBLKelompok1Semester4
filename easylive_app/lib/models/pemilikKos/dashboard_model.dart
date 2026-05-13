class Dashboard {
  final String name;
  final String kostName;
  final String date;
  final String price;
  final String status;
  final String idBooking;
  final String transactionId;
  final String paymentMethod;
  final int grossAmount;

  Dashboard({
    required this.name,
    required this.kostName,
    required this.date,
    required this.price,
    required this.status,
    required this.idBooking,
    required this.transactionId,
    required this.paymentMethod,
    required this.grossAmount,
  });
}