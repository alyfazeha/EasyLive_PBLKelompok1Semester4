import '../../models/pemilikJasa/detail_jasa_model.dart';

class DetailJasaController {
  DetailJasa getJasaDetail(String vehicleName) {
    final isTruck = vehicleName.toLowerCase().contains('truck');

    if (isTruck) {
      return DetailJasa(
        name: 'Truck',
        address: 'Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang',
        totalVehicle: 5,
        availableVehicle: 5,
        price: 'Rp 10.000 / km',
        description:
            'Truck pindahan dengan kapasitas besar untuk mengangkut barang rumah, kos, atau kebutuhan logistik yang lebih banyak dalam satu perjalanan.',
        images: [
          'assets/images/mobilBox-BackgroundRemover.jpg',
          'assets/images/mobilBox-BackgroundRemover.jpg',
        ],
        specifications: [
          'Kapasitas maksimal 700 kg',
          'Bak tertutup',
          'Cocok untuk barang besar',
          'Area layanan Malang',
        ],
      );
    }

    return DetailJasa(
      name: 'Pickup',
      address: 'Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang',
      totalVehicle: 10,
      availableVehicle: 1,
      price: 'Rp 8.000 / km',
      description:
          'Pickup praktis untuk pindahan ringan, pengiriman barang kos, perabot kecil, dan kebutuhan angkut cepat di area Malang.',
      images: [
        'assets/images/pickup-removed.png',
        'assets/images/pickup-removed.png',
      ],
      specifications: [
        'Kapasitas maksimal 200 kg',
        'Bak terbuka',
        'Cocok untuk pindahan ringan',
        'Area layanan Malang',
      ],
    );
  }
}
