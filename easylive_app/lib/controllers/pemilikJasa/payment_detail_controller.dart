import '../../models/pemilikJasa/payment_detail_model.dart';
import '../../models/pemilikJasa/dashboard_model.dart';

class PaymentDetailController {
  JasaPaymentDetailModel getPaymentDetail({
    required JasaPaymentHistory history,
  }) {
    return JasaPaymentDetailModel(
      ownerName: history.name,
      vehicleType: history.vehicleType,
      location: history.location,
      paymentDate: history.date,
      paymentMethod: history.paymentMethod,
      transactionId: history.transactionId,
      status: history.status,
      totalPayment: history.totalPayment,

      items: [
        JasaPaymentItem(
          title: 'Sewa Jasa',
          amount: history.totalPayment,
        ),
      ],
    );
  }

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'\\B(?=(\\d{3})+(?!\\d))'),
      (match) => '.',
    )}';
  }
}