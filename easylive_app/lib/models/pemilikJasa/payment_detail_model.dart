class JasaPaymentDetailModel {
  final String ownerName;
  final String vehicleType;
  final String location;
  final String paymentDate;
  final String paymentMethod;
  final String transactionId;
  final String status;
  final int totalPayment;

  final List<JasaPaymentItem> items;

  const JasaPaymentDetailModel({
    required this.ownerName,
    required this.vehicleType,
    required this.location,
    required this.paymentDate,
    required this.paymentMethod,
    required this.transactionId,
    required this.status,
    required this.totalPayment,
    required this.items,
  });
}

class JasaPaymentItem {
  final String title;
  final int amount;

  const JasaPaymentItem({
    required this.title,
    required this.amount,
  });
}