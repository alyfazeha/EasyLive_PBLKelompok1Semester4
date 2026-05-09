import 'package:flutter/material.dart';

import '../../../models/pemilikJasa/booking_model.dart';

class OwnerJasaBookingController extends ChangeNotifier {
  List<Booking> bookingList = [
    Booking(
      nama: "Budi Santoso",
      kendaraan: "Pickup - BOX",
      status: "pending",
      profileImage: 'https://i.pravatar.cc/120?img=1',
      tanggal: '09-12 Desember',
      jam: '08:00',
    ),
    Booking(
      nama: "Andi Wijaya",
      kendaraan: "Pickup - BOX",
      status: "aktif",
      profileImage: 'https://i.pravatar.cc/120?img=2',
      tanggal: '10-12 Desember',
      jam: '10:00',
    ),
    Booking(
      nama: "Siti Aminah",
      kendaraan: "Pickup - BOX",
      status: "aktif",
      profileImage: 'https://i.pravatar.cc/120?img=3',
      tanggal: '11-12 Desember',
      jam: '14:00',
    ),
    Booking(
      nama: "Rudi Hartono",
      kendaraan: "Pickup - BOX",
      status: "selesai",
      profileImage: 'https://i.pravatar.cc/120?img=4',
      tanggal: '08-12 Desember',
      jam: '09:00',
    ),
    Booking(
      nama: "Ahmad Fauzil",
      kendaraan: "Pickup - BOX",
      status: "pending",
      profileImage: 'https://i.pravatar.cc/120?img=5',
      tanggal: '15-12 Desember',
      jam: '13:00',
    ),
  ];

  String selectedFilter = "semua";
  String searchText = "";

  List<Booking> get filteredList {
    return bookingList.where((b) {
      final cocokSearch = b.nama.toLowerCase().contains(searchText.toLowerCase());

      final cocokFilter = selectedFilter == "semua"
          ? true
          : b.status == selectedFilter;

      return cocokSearch && cocokFilter;
    }).toList();
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void setSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  void approve(Booking b) {
    b.status = "aktif";
    notifyListeners();
  }

  void reject(Booking b) {
    bookingList.remove(b);
    notifyListeners();
  }

  void selesai(Booking b) {
    b.status = "selesai";
    notifyListeners();
  }
}

