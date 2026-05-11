class PaymentDetailModel {
  final String tenantName;
  final String roomNumber;
  final String kostName;
  final String paymentDate;
  final String paymentMethod;
  final String transactionId;
  final String status;
  final int totalPayment;
  final List<PaymentItem> items;

  PaymentDetailModel({
    required this.tenantName,
    required this.roomNumber,
    required this.kostName,
    required this.paymentDate,
    required this.paymentMethod,
    required this.transactionId,
    required this.status,
    required this.totalPayment,
    required this.items,
  });
}

class PaymentItem {
  final String title;
  final int amount;

  PaymentItem({
    required this.title,
    required this.amount,
  });
}