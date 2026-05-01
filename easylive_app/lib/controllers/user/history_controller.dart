import '../../models/user/history_model.dart';

class HistoryController {
  static const List<String> historyTypes = ['Kost', 'Jasa'];
  static const String defaultType = 'Kost';

  static final List<HistoryItem> _items = [
    HistoryItem(
      id: 'history-1',
      type: 'Kost',
      title: 'Kost Melati',
      location: 'Cengger Ayam',
      price: 'Rp 650.000/month',
      customerName: 'Ahmad Rafi Hamdi',
      ownerName: 'Kost Danisika',
      dateTime: DateTime(2026, 4, 21, 9, 0),
      status: 'Success',
    ),
    HistoryItem(
      id: 'history-2',
      type: 'Jasa',
      title: 'Laundry Express',
      location: 'Lowokwaru',
      price: 'Rp 35.000/order',
      customerName: 'Ahmad Rafi Hamdi',
      ownerName: 'Jasa Bersihku',
      dateTime: DateTime(2026, 4, 18, 14, 30),
      status: 'Success',
    ),
  ];

  static List<HistoryItem> getHistoriesByType(String type) {
    return _items.where((item) => item.type == type).toList();
  }

  static String formatHistoryDate(DateTime value) {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final dayName = dayNames[value.weekday - 1];
    final monthName = monthNames[value.month - 1];
    return '$hour:$minute, $dayName, ${value.day} $monthName ${value.year}';
  }
}
