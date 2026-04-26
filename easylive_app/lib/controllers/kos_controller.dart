import '../models/kos_model.dart';

class KostController {
  static List<KostModel> getAllKost() {
    return [
      KostModel(
        name: "Kost Melati",
        price: 650000,
        image: "assets/images/kos1.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Cengger Ayam",
        description:
            "Kost Melati khusus putri yang menawarkan fasilitas kamar mandi dalam, WiFi, dan kasur dengan harga terjangkau di kawasan Cengger Ayam.",
        specifications: [
          "4 x 5 meter",
          "en-suite bathroom",
          "Fan",
          "Spring Bed",
        ],
        facilities: ["Refrigerator", "Parking", "Kitchen"],
        availableRooms: 3,
      ),
      KostModel(
        name: "Kost Mawar",
        price: 1200000,
        image: "assets/images/kos2.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Soekarno",
        description:
            "Kost Mawar exclusive dengan fasilitas lengkap, AC, kamar mandi dalam, dan akses WiFi super cepat di pusat kota.",
        specifications: [
          "5 x 6 meter",
          "en-suite bathroom",
          "Air Conditioner",
          "King Size Bed",
        ],
        facilities: ["Refrigerator", "Parking", "Kitchen", "Laundry"],
        availableRooms: 2,
      ),
      KostModel(
        name: "Kost Anggrek",
        price: 900000,
        image: "assets/images/kos3.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Ijen",
        description:
            "Kost Anggrek nyaman untuk mahasiswa dengan suasana tenang, dekat kampus, dan fasilitas modern.",
        specifications: [
          "4 x 5 meter",
          "shared bathroom",
          "Air Conditioner",
          "Spring Bed",
        ],
        facilities: ["WiFi", "Parking", "Kitchen"],
        availableRooms: 5,
      ),
      KostModel(
        name: "Kost Dahlia",
        price: 750000,
        image: "assets/images/kos1.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Veteran",
        description:
            "Kost Dahlia hunian strategis dengan harga terjangkau, cocok untuk pekerja dan mahasiswa.",
        specifications: ["4 x 5 meter", "shared bathroom", "Fan", "Spring Bed"],
        facilities: ["WiFi", "Parking"],
        availableRooms: 4,
      ),
      KostModel(
        name: "Kost Lavender",
        price: 800000,
        image: "assets/images/kos2.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Sigura-gura",
        description:
            "Kost Lavender dengan desain modern, kamar bersih, dan lingkungan aman 24 jam.",
        specifications: [
          "4 x 5 meter",
          "en-suite bathroom",
          "Fan",
          "Spring Bed",
        ],
        facilities: ["Refrigerator", "Parking", "Kitchen"],
        availableRooms: 6,
      ),
      KostModel(
        name: "Kost Elite",
        price: 2500000,
        image: "assets/images/kos3.jpg",
        detailImage: "assets/images/kamarKos.jpg",
        address: "Jl. Lowokwaru",
        description:
            "Kost Elite premium dengan fasilitas hotel bintang 3, AC, water heater, dan layanan cleaning rutin.",
        specifications: [
          "6 x 7 meter",
          "en-suite bathroom",
          "Air Conditioner",
          "King Size Bed",
        ],
        facilities: ["Refrigerator", "Parking", "Kitchen", "Laundry", "Gym"],
        availableRooms: 1,
      ),
    ];
  }

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

  // Logic non-static untuk handle state di View (seperti tombol favorite)
  bool isFavorite = false;
  void toggleFavorite() => isFavorite = !isFavorite;
}
