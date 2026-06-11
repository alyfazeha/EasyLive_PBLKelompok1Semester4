import 'package:flutter/material.dart';
import '../../../models/user/kos_model.dart';
import '../../../core/color.dart';
import '../../../widgets/user/payment/invoice_widgets.dart';
import '../../../services/duitku_service.dart';
import 'duitku_webview.dart';

class InvoiceView extends StatefulWidget {
  final KostModel kost;
  final bool isJasa; // 1. Tambahkan flag ini
  final String? fromLocation; // 2. Tambahkan untuk data Jasa
  final String? toLocation; // 3. Tambahkan untuk data Jasa
  final double? jarakKm; // 4. Tambahkan untuk data Jasa
  final String namaPemesan; // dari PersonalInfoView
  final String nomorHP; // dari PersonalInfoView
  final DateTime? tanggalCheckin; // dari PersonalInfoView

  const InvoiceView({
    super.key,
    required this.kost,
    this.isJasa =
        false, // Default-kan false agar booking kos yang lama tidak error
    this.fromLocation,
    this.toLocation,
    this.jarakKm,
    required this.namaPemesan,
    required this.nomorHP,
     this.tanggalCheckin,
  });

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  bool _isPaymentMethodSelected = false;
  bool _isLoading = false;

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result = '.$result';
      result = priceStr[i] + result;
      count++;
    }
    return result;
  }

  /// ──────────────────────────────────────────────────
  // Tombol "Payment" ditekan → buat booking + invoice Kos
  // ──────────────────────────────────────────────────
  Future<void> _handlePayment(int total) async {
  if (!_isPaymentMethodSelected || _isLoading) return;

  setState(() => _isLoading = true);

  try {
    Map<String, dynamic> result;

    if (widget.isJasa) {
      // 1. Panggil service khusus Jasa jika isJasa = true
      result = await DuitkuService.createJasaBookingAndInvoice(
        idJasa: widget.kost.id ?? 0,
        namaJasa: widget.kost.name,
        totalBayar: total, // Menggunakan total keseluruhan yang sudah dihitung
        namaPemesan: widget.namaPemesan,
        nomorHP: widget.nomorHP,
        titikPenjemputan: widget.fromLocation ?? 'Tidak diketahui',
        titikTujuan: widget.toLocation ?? 'Tidak diketahui',
        jarakKm: widget.jarakKm ?? 0.0,
        tanggal: DateTime.now().day, // Menggunakan tanggal hari ini untuk transaksi jasa
        month: DateTime.now().month,
      );
    } else {
      // 2. Logika Kos seperti semula
      result = await DuitkuService.createBookingAndInvoice(
        idKost: widget.kost.id!,
        namaKost: widget.kost.name,
        hargaKost: widget.kost.price!,
        namaPemesan: widget.namaPemesan,
        nomorHP: widget.nomorHP,
        tanggalCheckin: widget.tanggalCheckin!,
      );
    }

    if (!mounted) return;

    // Navigasi ke WebView Pembayaran Duitku
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DuitkuWebView(
          paymentUrl: result['paymentUrl'],
          reference: result['reference'],
          idBookingKost: widget.isJasa ? null : result['idBookingKost'],
          idBookingJasa: widget.isJasa ? result['idBookingJasa'] : null,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal memproses pembayaran: $e')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final double subtotal = (widget.kost.price ?? 0).toDouble();
    
    // Tentukan biaya layanan secara dinamis di sini!
    final double biayaLayanan = widget.isJasa ? 15000.0 : 25000.0; 
    
    final double totalAll = subtotal + biayaLayanan;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildInvoiceHeader(context),
          const InvoiceStepper(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "payment details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("order subtotal", subtotal),
                        _buildPriceRow("biaya layanan", biayaLayanan),
                        const Divider(height: 30, color: AppColors.primary),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "total payment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              "Rp ${_formatPrice(totalAll.toInt())},-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "payment methods",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Pilihan QRIS
                  InkWell(
                    onTap: () => setState(
                      () =>
                          _isPaymentMethodSelected = !_isPaymentMethodSelected,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _isPaymentMethodSelected
                            ? AppColors.yellow.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isPaymentMethodSelected
                              ? AppColors.yellow
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPaymentMethodSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: _isPaymentMethodSelected
                                ? AppColors.yellow
                                : Colors.grey,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "QRIS / Semua Metode",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          if (_isPaymentMethodSelected)
                            const Text(
                              "Selected",
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildBottomBar(totalAll.toInt()),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Text(
            "Rp ${_formatPrice(amount.toInt())},-",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            "Invoice",
            style: TextStyle(
              fontSize: 22,
              color: AppColors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int total) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Rp ${_formatPrice(total)},-",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: (_isPaymentMethodSelected && !_isLoading)
                  ? () => _handlePayment(total)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade600,
                disabledForegroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 12,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Payment",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
