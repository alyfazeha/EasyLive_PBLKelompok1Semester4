class HistoryItem {
  final String id;
  final String type;
  final String title;
  final String location;
  final String price;
  final String customerName;
  final String ownerName;
  final DateTime dateTime;
  final String status;

  const HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.price,
    required this.customerName,
    required this.ownerName,
    required this.dateTime,
    required this.status,
  });
}
