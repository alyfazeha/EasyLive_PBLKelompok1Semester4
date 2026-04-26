import '../models/kos_model.dart';

class HomeController {

  static List<KostModel> getKostList() {
    return [
      KostModel(
        name: "Kost Melati",
        address: "Jl. Cengger Ayam",
<<<<<<< Updated upstream
        image: "images/kos1.jpg",
=======
        price: 650000,
        image: "assets/images/kos1.jpg",
>>>>>>> Stashed changes
      ),
      KostModel(
        name: "Kost Mawar",
        address: "Jl. Soekarno",
<<<<<<< Updated upstream
        image: "images/kos2.jpg",
=======
        price: 1200000,
        image: "assets/images/kos2.jpg",
>>>>>>> Stashed changes
      ),
      KostModel(
        name: "Kost Anggrek",
        address: "Jl. Ijen",
<<<<<<< Updated upstream
        image: "images/kos3.jpg",
=======
        price: 900000,
        image: "assets/images/kos3.jpg",
>>>>>>> Stashed changes
      ),
      KostModel(
        name: "Kost Dahlia",
        address: "Jl. Veteran",
<<<<<<< Updated upstream
        image: "images/kos1.jpg",
=======
        price: 750000,
        image: "assets/images/kos1.jpg",
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
>>>>>>> Stashed changes
      ),
    ];
  }

  static String getUserName() {
    return "Alyfa";
  }
}