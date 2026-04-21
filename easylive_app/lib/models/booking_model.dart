class Booking {
  final String title;
  final String location;
  final String price;
  final String status; // 'Active', 'Completed', 'Canceled'

  Booking({
    required this.title, 
    required this.location, 
    required this.price, 
    required this.status
  });
}