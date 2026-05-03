import 'package:flutter/material.dart';
import '../../../models/pemilikKos/booking_model.dart';

class BookingController extends ChangeNotifier {
  List<Booking> bookingList = [
    Booking(nama: "Budi Santoso", kamar: "Kamar 01 - Daniska Kost", status: "pending"),
    Booking(nama: "Andi Wijaya", kamar: "Kamar 01 - Daniska Kost", status: "aktif"),
    Booking(nama: "Siti Aminah", kamar: "Kamar 01 - Daniska Kost", status: "aktif"),
    Booking(nama: "Ahmad Fauzi", kamar: "Kamar 01 - Daniska Kost", status: "selesai"),
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