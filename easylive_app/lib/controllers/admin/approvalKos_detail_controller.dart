// approvalKos_detail_controller.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/admin/approvalKos_model.dart';

class ApprovalDetailController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Mengambil detail data kost berdasarkan id_kost
  Future<ApprovalDetailModel?> getApprovalDetail(String kostId) async {
    try {
      print('ID yang diterima: $kostId');

      final response = await supabase
          .from('kost')
          .select('''
            id_kost,
            nama_kost,
            nomor_hp,
            alamat,
            kecamatan,
            kota,
            deskripsi,
            status,
            alasan_tolak,
            gambar,
            owner:profiles!owner_id (
              full_name,
              email,
              photo
            )
          ''')
          .eq('id_kost', kostId)
          .single();

      print('Data ditemukan: $response');

      final owner = response['owner'] as Map<String, dynamic>?;

      // Ambil foto-foto kost
      final List<String> photos = (response['gambar'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();

      // Karena kolom avatar_url tidak ada di tabel profiles,
      // gunakan gambar default lokal
      const String defaultAvatar =
          'https://ui-avatars.com/api/?name=Owner&background=243B55&color=ffffff';

      final profilePhotoUrl =
          owner?['photo']?.toString().trim();
      final resolvedProfileImage =
          (profilePhotoUrl ?? '').isNotEmpty ? profilePhotoUrl! : defaultAvatar;

      return ApprovalDetailModel(
        ownerName: owner?['full_name']?.toString() ?? 'Unknown Owner',
        ownerRole: 'Kost Owner',
        status: response['status']?.toString() ?? 'pending',
        profileImage: resolvedProfileImage,

        businessName: response['nama_kost']?.toString() ?? '-',
        phoneNumber: response['nomor_hp']?.toString() ?? '-',
        email: owner?['email']?.toString() ?? '-',
        address:
            '${response['alamat'] ?? ''}, '
            '${response['kecamatan'] ?? ''}, '
            '${response['kota'] ?? ''}',
        description: response['deskripsi']?.toString() ?? '-',
        photos: photos,
        rejectionReason: response['alasan_tolak'] == null
            ? null
            : response['alasan_tolak'].toString(),
      );
    } catch (e) {
      print('Error getApprovalDetail: $e');
      return null;
    }
  }

  /// Approve kost
  Future<void> approveKost(String kostId) async {
    await supabase
        .from('kost')
        .update({'status': 'aktif', 'alasan_tolak': null})
        .eq('id_kost', kostId);
  }

  /// Reject kost
  Future<void> rejectKost(String kostId, String rejectionReason) async {
    final reason = rejectionReason.trim();
    if (reason.isEmpty) {
      throw Exception('Alasan menolak wajib diisi.');
    }

    await supabase
        .from('kost')
        .update({'status': 'ditolak', 'alasan_tolak': reason})
        .eq('id_kost', kostId);
  }
}
