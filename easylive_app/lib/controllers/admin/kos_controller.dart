import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/admin/kos_model.dart';

class ApprovalController {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Ambil daftar approval kost dari Supabase (sesuai DDL yang kamu berikan).
  ///
  /// DDL kost: id_kost, owner_id, nama_kost, status, alasan_tolak, gambar (text[])
  ///
  /// Catatan: untuk daftar owner (full_name/username) kita join ke tabel `profiles`.
  Future<List<ApprovalModel>> getApprovalRequests() async {
    final res = await _supabase
        .from('kost')
        .select(
          'id_kost, nama_kost, status, alasan_tolak, gambar, owner_id, profiles!inner(full_name, username)',
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

      // owner name dari join
      final profile = item['profiles'] as Map<String, dynamic>?;
      final fullName = (profile?['full_name'] ?? '').toString();
      final username = (profile?['username'] ?? '').toString();
      final ownerName = fullName.isNotEmpty ? fullName : username;

      // gambar = text[]; ambil item pertama sebagai cover
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

  /// Backward compatibility untuk halaman yang masih memanggil sink.
  /// Jangan dipakai untuk logic utama.
  List<ApprovalModel> getApprovalRequestsSyncFallback() {
    return const [];
  }
}
