import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/color.dart';
import 'payment_result_view.dart';

class DuitkuWebView extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final int? idBookingKost;
  final int? idBookingJasa;


  const DuitkuWebView({
    super.key,
    required this.paymentUrl,
    required this.reference,
    this.idBookingKost,
    this.idBookingJasa,
  });

  @override
  State<DuitkuWebView> createState() => _DuitkuWebViewState();
}

class _DuitkuWebViewState extends State<DuitkuWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // URL yang kamu set sebagai returnUrl di Edge Function
  // Duitku akan redirect ke sini setelah pembayaran selesai / dibatalkan
  static const String _returnUrl = 'https://ngekost.app/payment/return';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (request) {
            // Tangkap redirect dari returnUrl Duitku
            if (request.url.startsWith(_returnUrl)) {
              final uri = Uri.parse(request.url);
              final resultCode = uri.queryParameters['resultCode'] ?? '01';
              _handlePaymentResult(resultCode);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentResult(String resultCode) {
    // Pindah ke halaman hasil pembayaran
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentResultView(
          resultCode: resultCode,
          reference: widget.reference,
          idBookingKost: widget.idBookingKost,
          idBookingJasa: widget.idBookingJasa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => _showCancelDialog(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, color: AppColors.primary, size: 20),
          ),
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Memuat halaman pembayaran...',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Batalkan Pembayaran?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar? Pembayaran belum selesai.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjutkan Bayar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              Navigator.pop(context); // keluar dari WebView
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}