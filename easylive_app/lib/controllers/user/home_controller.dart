import '../../models/user/kos_model.dart';

class HomeController {
  static List<KostModel> getKostList() {
    return [
      KostModel(
        name: "Kost Melati",
        price: 650000,
        image: "assets/images/kos1.jpg",
        address: "Jl. Cengger Ayam",
      ),
      KostModel(
        name: "Kost Mawar",
        price: 1200000,
        image: "assets/images/kos2.jpg",
        address: "Jl. Soekarno",
      ),
      KostModel(
        name: "Kost Anggrek",
        price: 900000,
        image: "assets/images/kos3.jpg",
        address: "Jl. Ijen",
      ),
      KostModel(
        name: "Kost Melati",
        price: 650000,
        image: "assets/images/kos1.jpg",
        address: "Jl. Cengger Ayam",
      ),  
      KostModel(
        name: "Kost Mawar",
        price: 1200000,
        image: "assets/images/kos2.jpg",
        address: "Jl. Soekarno",
      ),
      KostModel(
        name: "Kost Anggrek",
        price: 900000,
        image: "assets/images/kos3.jpg",
        address: "Jl. Ijen",
      ),
    ];
  }

  static String getUserName() {
    return "Alyfa";
  }
}
