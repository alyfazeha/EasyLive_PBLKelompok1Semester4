import 'package:flutter/material.dart';
import '../../../controllers/pemilikJasa/detail_jasa_controller.dart';
import '../../../models/pemilikJasa/detail_jasa_model.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/detailJasa.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import './editKendaraan_view.dart';

class DetailJasaView extends StatefulWidget {
  final String idJasa;

  DetailJasaView({super.key, required this.idJasa});

  @override
  State<DetailJasaView> createState() => _DetailJasaViewState();
}

class _DetailJasaViewState extends State<DetailJasaView> {
  final controller = DetailJasaController();
  DetailJasa? jasa;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await controller.getJasaDetailById(widget.idJasa);
      setState(() {
        jasa = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.primary,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Detail Jasa',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (jasa != null)
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditKendaraanView(jasa: jasa!),
                          ),
                        );
                        if (result == true) {
                          _loadData(); // refresh setelah edit
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : jasa == null
                    ? const Expanded(
                        child: Center(child: Text('Gagal memuat data')),
                      )
                    : Expanded(child: DetailJasaWidget(jasa: jasa!)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: PemilikJasaBottomNav(
            currentIndex: 2,
            onNavigate: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa/dashboard',
                );
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
              }
            },
          ),
        ),
      ),
    );
  }
}