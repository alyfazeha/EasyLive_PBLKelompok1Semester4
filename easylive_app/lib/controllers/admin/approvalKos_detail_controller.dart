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
            gambar,
            owner:profiles!owner_id (
              full_name,
              email
            )
          ''')
          .eq('id_kost', kostId)
          .single();

      print('Data ditemukan: $response');

      final owner = response['owner'] as Map<String, dynamic>?;

      // Ambil foto-foto kost
<<<<<<< HEAD
      final List<String> photos =
          (response['gambar'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList();
=======
      final List<String> photos = (response['gambar'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
>>>>>>> rafi

      // Karena kolom avatar_url tidak ada di tabel profiles,
      // gunakan gambar default lokal
      const String defaultAvatar =
          'https://ui-avatars.com/api/?name=Owner&background=243B55&color=ffffff';

      return ApprovalDetailModel(
<<<<<<< HEAD
        ownerName:
            owner?['full_name']?.toString() ?? 'Unknown Owner',
        ownerRole: 'Kost Owner',
        status:
            response['status']?.toString() ?? 'Pending',
        profileImage: defaultAvatar,
        businessName:
            response['nama_kost']?.toString() ?? '-',
        phoneNumber:
            response['nomor_hp']?.toString() ?? '-',
        email:
            owner?['email']?.toString() ?? '-',
=======
        ownerName: owner?['full_name']?.toString() ?? 'Unknown Owner',
        ownerRole: 'Kost Owner',
        status: response['status']?.toString() ?? 'Pending',
        profileImage: defaultAvatar,
        businessName: response['nama_kost']?.toString() ?? '-',
        phoneNumber: response['nomor_hp']?.toString() ?? '-',
        email: owner?['email']?.toString() ?? '-',
>>>>>>> rafi
        address:
            '${response['alamat'] ?? ''}, '
            '${response['kecamatan'] ?? ''}, '
            '${response['kota'] ?? ''}',
<<<<<<< HEAD
        description:
            response['deskripsi']?.toString() ?? '-',
=======
        description: response['deskripsi']?.toString() ?? '-',
>>>>>>> rafi
        photos: photos,
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
<<<<<<< HEAD
        .update({
          'status': 'approved',
        })
=======
        .update({'status': 'approved'})
>>>>>>> rafi
        .eq('id_kost', kostId);
  }

  /// Reject kost
  Future<void> rejectKost(String kostId) async {
    await supabase
        .from('kost')
<<<<<<< HEAD
        .update({
          'status': 'rejected',
        })
        .eq('id_kost', kostId);
  }
}
=======
        .update({'status': 'rejected'})
        .eq('id_kost', kostId);
  }
}
>>>>>>> rafi
