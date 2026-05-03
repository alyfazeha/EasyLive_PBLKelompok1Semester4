import '../../models/pemilikKos/detailKamar_models.dart';

class KostController {
  Kost getKostDetail() {
    return Kost(
      name: "Daniska Kost",
      address: "Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang",
      totalRoom: 30,
      availableRoom: 1,
      price: "Rp 4.500.000 / bulan",
      description:
          "Kost nyaman dan aman dekat kampus. Fasilitas lengkap, lingkungan bersih, dan strategis",
      images: [
        "assets/images/kos1.jpg",
        "assets/images/kos1.jpg",
      ],
      facilities: [
        "WiFi",
        "AC",
        "Kamar Mandi Dalam",
        "Parkir",
        "Dapur Bersama",
        "Laundry"
      ],
    );
  }
}
