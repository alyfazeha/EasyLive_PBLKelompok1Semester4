import '../../models/pemilikKos/payment_detail_model.dart';

class PaymentDetailController {
  PaymentDetailModel getPaymentDetail() {
    return PaymentDetailModel(
      tenantName: 'Budi Santoso',
      roomNumber: '03',
      kostName: 'Daniska Kos',
      paymentDate: '01 Mei 2026',
      paymentMethod: 'Transfer Bank',
      transactionId: 'TRX250501001',
      status: 'Lunas',
      totalPayment: 5500000,
      items: [
        PaymentItem(title: 'Sewa Kamar (Mei 2026)', amount: 5000000),
        PaymentItem(title: 'Listrik', amount: 300000),
        PaymentItem(title: 'Air', amount: 150000),
        PaymentItem(title: 'WiFi', amount: 50000),
      ],
    );
  }

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }
}