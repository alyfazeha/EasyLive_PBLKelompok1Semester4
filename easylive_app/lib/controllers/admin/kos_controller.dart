import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/admin/kos_model.dart';

class ApprovalController {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String defaultAvatar =
      'https://ui-avatars.com/api/?name=Owner&background=243B55&color=ffffff';

  Future<List<ApprovalModel>> getApprovalRequests() async {
    final res = await _supabase
        .from('kost')
        .select(
          'id_kost, nama_kost, status, alasan_tolak, gambar, owner_id, profiles!inner(full_name, username, photo)',
        )
        .order('id_kost', ascending: false)
        .limit(50);

    final list = (res as List?) ?? <dynamic>[];
    final approvals = <ApprovalModel>[];

    for (final item in list) {
      final id = (item['id_kost'] ?? '').toString();
      final status = (item['status'] ?? 'pending').toString();
      final rejectionReason = item['alasan_tolak'] == null
          ? null
          : item['alasan_tolak'].toString();

      final profile = item['profiles'] as Map<String, dynamic>?;
      final fullName = (profile?['full_name'] ?? '').toString();
      final username = (profile?['username'] ?? '').toString();
      final ownerName = fullName.isNotEmpty ? fullName : username;

      // ← fix: fallback ke defaultAvatar
      final profilePhotoUrl = (profile?['photo'] ?? '').toString().trim();

      final gambar = item['gambar'];
      String imageUrl = '';
      if (gambar is List && gambar.isNotEmpty) {
        imageUrl = (gambar.first ?? '').toString();
      } else {
        imageUrl = (gambar ?? '').toString();
      }

      approvals.add(
        ApprovalModel(
          id: id,
          name: ownerName.isNotEmpty ? ownerName : '-',
          propertyName: (item['nama_kost'] ?? '').toString().isNotEmpty
              ? (item['nama_kost'] ?? '').toString()
              : '-',
          submittedDate: '',
          status: status,
          imageUrl: imageUrl,
          profilePhotoUrl: profilePhotoUrl.isNotEmpty // ← fix
              ? profilePhotoUrl
              : defaultAvatar,
          rejectionReason:
              (status.toLowerCase() == 'ditolak' ||
                  status.toLowerCase() == 'rejected')
              ? rejectionReason
              : null,
        ),
      );
    }

    return approvals;
  }

  List<ApprovalModel> getApprovalRequestsSyncFallback() {
    return const [];
  }
}