class DetailJasa {
  final String idJasa;
  final String name;
  final String address;
  final String kecamatan;
  final String kota;
  final String nomorHp;
  final String nomorPlat;
  final String kapasitas;
  final String tipeMobil;
  final int totalVehicle;
  final String price;
  final String description;
  final List<String> images;
  final String status;

  DetailJasa({
    required this.idJasa,
    required this.name,
    required this.address,
    required this.kecamatan,
    required this.kota,
    required this.nomorHp,
    required this.nomorPlat,
    required this.kapasitas,
    required this.tipeMobil,
    required this.totalVehicle,
    required this.price,
    required this.description,
    required this.images,
    required this.status,
  });
}