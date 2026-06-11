import 'package:flutter/material.dart';

class PemilikKosModel {
  final String ownerName;
  final String welcomeMessage;
  final int totalKost;
  final int availableRooms;
  final double totalIncome;
  final int newBookings;
  final int occupiedRooms;
  final int totalRooms;
  final List<KostData> kostList;
  final String userImage;

  const PemilikKosModel({
    required this.ownerName,
    required this.welcomeMessage,
    required this.totalKost,
    required this.availableRooms,
    required this.totalIncome,
    required this.newBookings,
    required this.occupiedRooms,
    required this.totalRooms,
    required this.kostList,
    required this.userImage,
  });
}

class KostData {
  final String idKost;
  final String name;
  final List<String> gambar;
  final String price;
  final String status;
  final String statusColor;
  final String emptyRoom;
  final String alamat;
  final int jumlahKamar;
  final int kamarKosong;

  const KostData({
    required this.idKost,
    required this.name,
    required this.gambar,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.emptyRoom,
    required this.alamat,
    required this.jumlahKamar,
    required this.kamarKosong,
  });

  /// Ambil gambar pertama dari Supabase,
  /// fallback ke asset lokal kalau kosong
  String get firstImage =>
      gambar.isNotEmpty ? gambar[0] : 'assets/images/kos1.jpg';

  /// Apakah gambar dari network (Supabase) atau asset lokal
  bool get isNetworkImage => firstImage.startsWith('http');

  /// Widget gambar yang otomatis pilih network atau asset
  Widget get imageWidget => isNetworkImage
      ? Image.network(
          firstImage,
          width: 140,
          height: 88,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/kos1.jpg',
            width: 140,
            height: 88,
            fit: BoxFit.cover,
          ),
        )
      : Image.asset(
          firstImage,
          width: 140,
          height: 88,
          fit: BoxFit.cover,
        );

  /// Warna status sebagai Color
  Color get statusColorValue {
    switch (status.toLowerCase()) {
      case 'aktif':
        return const Color(0xFF31B75D);
      case 'ditolak':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFFFAB00); // pending = kuning
    }
  }
}