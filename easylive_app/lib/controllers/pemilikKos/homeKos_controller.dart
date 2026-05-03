import 'package:flutter/material.dart';
import '../../models/pemilikKos/pemilikKos_model.dart';

class PemilikKosController extends ChangeNotifier {
  bool _isLoading = false;
  PemilikKosModel? _model;

  bool get isLoading => _isLoading;
  PemilikKosModel? get model => _model;

  PemilikKosController() {
    _loadData();
  }

  void removeKost(int index) {
    if (_model != null && index < _model!.kostList.length) {
      final list = List<KostData>.from(_model!.kostList);
      list.removeAt(index);
      _model = PemilikKosModel(
        ownerName: _model!.ownerName,
        welcomeMessage: _model!.welcomeMessage,
        totalKost: _model!.totalKost - 1,
        availableRooms: _model!.availableRooms,
        totalIncome: _model!.totalIncome,
        newBookings: _model!.newBookings,
        occupiedRooms: _model!.occupiedRooms,
        totalRooms: _model!.totalRooms,
        kostList: list,
      );
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data - replace with actual Supabase query later
      _model = const PemilikKosModel(
        ownerName: 'Rafi',
        welcomeMessage: 'EasyLive !',
        totalKost: 5,
        availableRooms: 12,
        totalIncome: 22500000,
        newBookings: 18,
        occupiedRooms: 30,
        totalRooms: 50,
        kostList: [
          KostData(
            name: 'Daniska Kos',
            image: 'assets/images/kos1.jpg',
            price: 'Rp 1.500.000 / bulan',
            status: 'Aktif',
            statusColor: '0xFF31B75D',
            emptyRoom: '1 Kosong',
          ),
          KostData(
            name: 'Triple A',
            image: 'assets/images/kos2.jpg',
            price: 'Rp 900.000 / bulan',
            status: 'Penuh',
            statusColor: '0xFFE53935',
            emptyRoom: '5 Kosong',
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error loading pemilik kos data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  void updateNotificationCount(int count) {
    // Update notification count if needed
    notifyListeners();
  }
}
