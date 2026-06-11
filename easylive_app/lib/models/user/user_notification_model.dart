enum UserNotificationType { dikonfirmasi, ditolak, selesai }

enum BookingSource { kos, jasa }

class UserNotification {
  final String id;
  final String title;
  final String description;
  final UserNotificationType type;
  final BookingSource source;

  const UserNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.source,
  });
}