import '../../models/pemilikJasa/payment_detail_model.dart';

class PaymentDetailController {
  JasaPaymentDetailModel getPaymentDetail() {
    return const JasaPaymentDetailModel(
      ownerName: 'Rafi',
      vehicleType: 'Pickup',
      location: 'Daniska KOS',
      paymentDate: '01 Mei 2026',
      paymentMethod: 'Transfer Bank',
      transactionId: 'TRX250501001',
      status: 'Lunas',
      totalPayment: 5500000,
      items: [
        JasaPaymentItem(title: 'Sewa Jasa (Mei 2026)', amount: 5000000),
        JasaPaymentItem(title: 'Biaya Pickup', amount: 300000),
        JasaPaymentItem(title: 'Biaya Perjalanan', amount: 150000),
        JasaPaymentItem(title: 'Biaya Administrasi', amount: 50000),
      ],
    );
  }

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'\\B(?=(\\d{3})+(?!\\d))'), (match) => '.')}';
  }
}
