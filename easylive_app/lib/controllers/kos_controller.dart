import '../models/kos_model.dart';

class KostController {
  static List<KostModel> getAllKost() {
    return [
      // Data lengkap untuk Detail
      KostModel(
        name: "DANISKA KOS",
        price: 1500000,
        image: "assets/images/kamarKos.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Lowokwaru, Malang",
        description: "Kost Daniska khusus putri yang menawarkan fasilitas kamar mandi dalam, WiFi, dan kasur dengan harga terjangkau di kawasan Lowokwaru.",
        specifications: ["4 x 6 meter", "en-suite bathroom", "Air Conditioner", "Spring Bed"],
        facilities: ["Refrigerator", "Parking", "Kitchen"],
        availableRooms: 5,
      ),
      // Data lama milikmu
      KostModel(name: "Kost Melati", price: 650000, image: "assets/images/kos1.jpg", address: "Cengger Ayam"),
      KostModel(name: "Kost Mawar", price: 1200000, image: "assets/images/kos2.jpg", address: "Suhat"),
      KostModel(name: "Kost Elite", price: 2500000, image: "assets/images/kos1.jpg", address: "Lowokwaru"),
      KostModel(name: "Kost Lavender", price: 800000, image: "assets/images/kos2.jpg", address: "Sigura-gura"),
    ];
  }

  static List<KostModel> filterKost(List<KostModel> allKost, String query, String location, double maxPrice) {
    return allKost.where((kost) {
      final matchesSearch = kost.name.toLowerCase().contains(query.toLowerCase()) ||
          kost.address.toLowerCase().contains(query.toLowerCase());
      final matchesLoc = location == "All Address" || kost.address.toLowerCase().contains(location.toLowerCase());
      final matchesPrice = (kost.price ?? 0) <= maxPrice;
      return matchesSearch && matchesLoc && matchesPrice;
    }).toList();
  }

  // Logic non-static untuk handle state di View (seperti tombol favorite)
  bool isFavorite = false;
  void toggleFavorite() => isFavorite = !isFavorite;
}