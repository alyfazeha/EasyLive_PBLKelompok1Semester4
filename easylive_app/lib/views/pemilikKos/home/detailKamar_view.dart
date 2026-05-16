import 'package:flutter/material.dart';
import '../../../controllers/pemilikKos/detailKamar_controller.dart';
import '../../../models/pemilikKos/detailKamar_models.dart';
import '../../../widgets/pemilikKos/home/detailKamar.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../../../core/color.dart';

class DetailKostView extends StatefulWidget {
  final String idKost;

  const DetailKostView({super.key, required this.idKost});

  @override
  State<DetailKostView> createState() => _DetailKostViewState();
}

class _DetailKostViewState extends State<DetailKostView> {
  final controller = KostController();
  Kost? kost;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await controller.getKostDetail(widget.idKost);
      setState(() {
        kost = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER — tidak diubah
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.darkBlue,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.darkBlue,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Detail Kost",
                    style: TextStyle(color: AppColors.background, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert, color: AppColors.background),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : kost == null
                  ? const Center(child: Text("Gagal memuat data"))
                  : DetailKostWidget(kost: kost!),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNav(
        currentIndex: 2,
        onNavigate: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
          }
        },
      ),
    );
  }
}
