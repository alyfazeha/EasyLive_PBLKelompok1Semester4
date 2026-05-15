import '../../models/pemilikKos/payment_detail_model.dart';
import '../../models/pemilikKos/dashboard_model.dart';

class PaymentDetailController {
  final PaymentDetailModel payment;

  PaymentDetailController({required Dashboard dashboard})
      : payment = PaymentDetailModel.fromDashboard(dashboard);

  PaymentDetailModel getPaymentDetail() => payment;

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }
}