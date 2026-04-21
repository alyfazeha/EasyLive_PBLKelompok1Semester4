import '../models/kos_model.dart';

class KostController {

  static List<KostModel> getAllKost() {
    return [
      KostModel(
        name: "Kost Melati",
        price: 650000,
        image: "assets/images/kos1.jpg",
        address: "Cengger Ayam",
      ),
      KostModel(
        name: "Kost Mawar",
        price: 1200000,
        image: "assets/images/kos2.jpg",
        address: "Suhat",
      ),
      KostModel(
        name: "Kost Elite",
        price: 2500000,
        image: "assets/images/kos1.jpg",
        address: "Lowokwaru",
      ),
      KostModel(
        name: "Kost Lavender",
        price: 800000,
        image: "assets/images/kos2.jpg",
        address: "Sigura-gura",
      ),
      KostModel(
        name: "Kost Melati 2",
        price: 700000,
        image: "assets/images/kos1.jpg",
        address: "Cengger Ayam",
      ),
      KostModel(
        name: "Kost Bangunan Baru",
        price: 1500000,
        image: "assets/images/kos2.jpg",
        address: "Lowokwaru",
      ),
    ];
  }

  /// FILTER LOGIC 
  static List<KostModel> filterKost(
    List<KostModel> allKost,
    String query,
    String location,
    double maxPrice,
  ) {
    return allKost.where((kost) {
      final matchesSearch =
          kost.name.toLowerCase().contains(query.toLowerCase()) ||
          kost.address.toLowerCase().contains(query.toLowerCase());

      final matchesLoc =
          location == "All Address" ||
          kost.address.toLowerCase().contains(location.toLowerCase());

      final matchesPrice = (kost.price ?? 0) <= maxPrice;

      return matchesSearch && matchesLoc && matchesPrice;
    }).toList();
  }
}
