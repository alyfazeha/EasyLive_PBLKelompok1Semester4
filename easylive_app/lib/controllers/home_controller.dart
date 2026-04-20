import '../models/kos_model.dart';

class HomeController {

  static List<KostModel> getKostList() {
    return [
      KostModel(
        name: "Kost Melati",
        address: "Jl. Cengger Ayam",
        image: "images/kos1.jpg",
      ),
      KostModel(
        name: "Kost Mawar",
        address: "Jl. Soekarno",
        image: "images/kos2.jpg",
      ),
      KostModel(
        name: "Kost Anggrek",
        address: "Jl. Ijen",
        image: "images/kos3.jpg",
      ),
      KostModel(
        name: "Kost Dahlia",
        address: "Jl. Veteran",
        image: "images/kos1.jpg",
      ),
    ];
  }

  static String getUserName() {
    return "Rafi";
  }
}