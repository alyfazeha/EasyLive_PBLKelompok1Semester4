class PemilikKosModel {
  final String ownerName;
  final String welcomeMessage;
  final int totalKost;
  final int availableRooms;
  final double totalIncome;
  final int newBookings;
  final int occupiedRooms;
  final int totalRooms;
  final List<KostData> kostList;

  const PemilikKosModel({
    required this.ownerName,
    required this.welcomeMessage,
    required this.totalKost,
    required this.availableRooms,
    required this.totalIncome,
    required this.newBookings,
    required this.occupiedRooms,
    required this.totalRooms,
    required this.kostList,
  });
}

class KostData {
  final String name;
  final String image;
  final String price;
  final String status;
  final String statusColor;
  final String emptyRoom;

  const KostData({
    required this.name,
    required this.image,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.emptyRoom,
  });
}
