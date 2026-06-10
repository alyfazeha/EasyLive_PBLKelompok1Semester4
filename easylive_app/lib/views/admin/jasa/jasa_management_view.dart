// views/admin/jasa/admin_jasa_management_view.dart

import 'package:flutter/material.dart';

import '../../../controllers/admin/approval_jasa_controller.dart';
import '../../../models/admin/approval_jasa_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/jasa/jasa_card.dart';
import '../../../widgets/admin/kos/approval_tab_filter.dart';
import '../../../widgets/common/back_button_widget.dart';
import 'detail_jasa_view.dart';

class AdminJasaManagementView extends StatefulWidget {
  const AdminJasaManagementView({super.key});

  @override
  State<AdminJasaManagementView> createState() =>
      _AdminJasaManagementViewState();
}

class _AdminJasaManagementViewState
    extends State<AdminJasaManagementView> {
  final ApprovalJasaController _controller =
      ApprovalJasaController();

  // Tab label → status value di Supabase
  // 'All' = null (tidak filter), lainnya sesuai status kolom
  final List<String> tabs = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  // Map tab label ke nilai status Supabase
  final Map<String, String?> _tabToStatus = {
    'All': null,
    'Pending': 'pending',
    'Approved': 'aktif',
    'Rejected': 'ditolak',
  };

  int selectedTabIndex = 0;

  List<ApprovalJasaModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJasa();
  }

  /// Fetch dari Supabase sesuai tab aktif
  Future<void> _fetchJasa() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final selectedTab = tabs[selectedTabIndex];
    final statusFilter = _tabToStatus[selectedTab];

    final result = await _controller.getJasaList(
      statusFilter: statusFilter,
    );

    if (!mounted) return;

    setState(() {
      _items = result;
      _isLoading = false;
    });
  }

  void _onTabChanged(int index) {
    setState(() => selectedTabIndex = index);
    _fetchJasa();
  }

  // ─── STATUS UPDATE LOKAL (optimistic) ──────────────────────────────────────

  void _updateLocalStatus(String idJasa, String status,
      {String? rejectionReason}) {
    setState(() {
      _items = _items.map((item) {
        if (item.idJasa == idJasa) {
          // Rebuild dengan field baru menggunakan fromMap tidak ideal karena
          // kita tidak punya raw map — buat copyWith manual via factory helper.
          return _copyWithStatus(
            item,
            status: status,
            rejectionReason: rejectionReason,
          );
        }
        return item;
      }).toList();
    });
  }

  /// Helper copyWith karena model tidak auto-generate copyWith
  ApprovalJasaModel _copyWithStatus(
    ApprovalJasaModel item, {
    required String status,
    String? rejectionReason,
  }) {
    return ApprovalJasaModel(
      idJasa: item.idJasa,
      namaJasa: item.namaJasa,
      tipeMobil: item.tipeMobil,
      priceMobil: item.priceMobil,
      priceKm: item.priceKm,
      gambar: item.gambar,
      status: status,
      alamat: item.alamat,
      kecamatan: item.kecamatan,
      kota: item.kota,
      nomorHp: item.nomorHp,
      nomorPlat: item.nomorPlat,
      kapasitas: item.kapasitas,
      deskripsi: item.deskripsi,
      rejectionReason: rejectionReason ?? item.rejectionReason,
      ownerName: item.ownerName,
      ownerEmail: item.ownerEmail,
      ownerProfileImage: item.ownerProfileImage,
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/admin');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
        bottomNavigationBar: AdminBottomNavbar(
          selectedIndex: 3,
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/admin');
                return;
              case 1:
                Navigator.pushReplacementNamed(
                    context, '/admin/history');
                return;
              case 2:
                Navigator.pushReplacementNamed(
                    context, '/admin/kos');
                return;
              case 3:
                return;
              case 4:
                Navigator.pushReplacementNamed(
                    context, '/admin/profile');
                return;
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF243B55),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButtonWidget(
                backgroundColor: const Color(0xFFF6BE00),
                iconColor: const Color(0xFF243447),
                size: 42,
                iconSize: 18,
                borderRadius: 12,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/admin',
                    (route) => false,
                  );
                },
              ),
              const Text(
                'Jasa Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, '/admin/notifikasi'),
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ApprovalTabFilter(
            tabs: tabs,
            selectedIndex: selectedTabIndex,
            onTap: _onTabChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF243B55),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchJasa,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data jasa.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchJasa,
      color: const Color(0xFF243B55),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Jasa Owner Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JasaCard(
                title: item.ownerName,
                subtitle: item.namaJasa,
                submittedDate: item.fullAddress,
                status: item.status,
                // Tampilkan gambar pertama jika ada, fallback ke asset default
                imageAsset: item.ownerProfileImage.trim().isNotEmpty
                    ? item.ownerProfileImage
                    : 'assets/images/jasa_icon_motor.png',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminJasaDetailView(
                        idJasa: item.idJasa,
                      ),
                    ),
                  );

                  if (result is Map) {
                    if (result['status'] == 'approved') {
                      _updateLocalStatus(item.idJasa, 'aktif');

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${item.namaJasa} disetujui'),
                        ),
                      );
                    } else if (result['status'] == 'rejected') {
                      _updateLocalStatus(
                        item.idJasa,
                        'ditolak',
                        rejectionReason:
                            result['reason']?.toString() ?? '',
                      );

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${item.namaJasa} ditolak'),
                        ),
                      );
                    }
                  }

                  // Refresh untuk sinkronisasi penuh
                  _fetchJasa();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}