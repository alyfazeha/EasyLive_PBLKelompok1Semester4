import '../../models/user/kos_model.dart';

class HomeController {
  static List<KostModel> getKostList() {
    return [
      KostModel(
        name: "Kost Melati",
        price: 650000,
        image: "assets/images/kos1.jpg",
        address: "Jl. Cengger Ayam",
        description:
            "Kost nyaman dengan fasilitas lengkap dekat kampus. AC, kamar mandi dalam, WiFi gratis.",
        specifications: ["AC", "Kasur Single", "Lemari", "Meja Belajar"],
        facilities: ["WiFi", "Laundry", "Parkir", "Keamanan 24 Jam"],
        availableRooms: 5,
        detailImage: "assets/images/kamarKos.jpg",
      ),
      KostModel(
        name: "Kost Mawar",
        price: 1200000,
        image: "assets/images/kos2.jpg",
        address: "Jl. Soekarno",
        description:
            "Kost premium dengan view kota dan fasilitas mewah. Kolam renang, gym, dapur bersama.",
        specifications: ["AC", "Kasur Queen", "TV", "Kamar Mandi Dalam"],
        facilities: ["Pool", "Gym", "Dapur", "Security"],
        availableRooms: 3,
        detailImage: "assets/images/kamarKos.jpg",
      ),
      KostModel(
        name: "Kost Anggrek",
        price: 900000,
        image: "assets/images/kos3.jpg",
        address: "Jl. Ijen",
        description:
            "Kost putra/putri dengan akses mudah ke pusat kota. Parkir luas, dekat transportasi umum.",
        specifications: ["Fan", "Kasur Bunkbed", "Lemari", "KWH Mandiri"],
        facilities: ["Laundry", "Musholla", "Parkir Motor", "CCTV"],
        availableRooms: 8,
        detailImage: "assets/images/kamarKos.jpg",
      ),
      // Duplicate for testing show more
      KostModel(
        name: "Kost Melati 2",
        price: 700000,
        image: "assets/images/kos1.jpg",
        address: "Jl. Cengger Ayam No.2",
        description:
            "Kost nyaman dengan fasilitas lengkap dekat kampus. AC, kamar mandi dalam, WiFi gratis.",
        specifications: ["AC", "Kasur Single", "Lemari"],
        facilities: ["WiFi", "Laundry"],
        availableRooms: 4,
        detailImage: "assets/images/kamarKos.jpg",
      ),
      KostModel(
        name: "Kost Mawar 2",
        price: 1300000,
        image: "assets/images/kos2.jpg",
        address: "Jl. Soekarno No.45",
        description: "Kost premium dengan view kota dan fasilitas mewah.",
        specifications: ["AC", "Kasur Queen"],
        facilities: ["Pool", "Gym"],
        availableRooms: 2,
        detailImage: "assets/images/kamarKos.jpg",
      ),
      KostModel(
        name: "Kost Anggrek 2",
        price: 950000,
        image: "assets/images/kos3.jpg",
        address: "Jl. Ijen No.78",
        description: "Kost putra/putri dengan akses mudah ke pusat kota.",
        specifications: ["Fan", "Kasur Bunkbed"],
        facilities: ["Laundry", "Parkir"],
        availableRooms: 6,
        detailImage: "assets/images/kamarKos.jpg",
      ),
    ];
  }

  static String getUserName() {
    return "Alyfa";
  }
}
