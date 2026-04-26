import '../models/kos_model.dart';

class HomeController {
  static List<KostModel> getKostList() {
    return [
      KostModel(
        name: "Kost Melati",
        address: "Jl. Cengger Ayam",

        image: "assets/images/kos1.jpg",

        price: 650000,
      ),
      KostModel(
        name: "Kost Mawar",
        address: "Jl. Soekarno",
        image: "assets/images/kos2.jpg",
        price: 1200000,
      ),
      KostModel(
        name: "Kost Anggrek",
        address: "Jl. Ijen",
        image: "assets/images/kos3.jpg",
        price: 900000,
      ),
      KostModel(
        name: "Kost Dahlia",
        address: "Jl. Veteran",
        image: "assets/images/kos1.jpg",
        price: 750000,
      ),
      KostModel(
        name: "Kost Anggrek",
        address: "Jl. Ijen",
        price: 900000,
        image: "assets/images/kos3.jpg",
      ),
      KostModel(
        name: "Kost Dahlia",
        address: "Jl. Veteran",
        price: 750000,
        image: "assets/images/kos1.jpg",
      ),
    ];
  }

  static String getUserName() {
    return "Alyfa";
  }
}
