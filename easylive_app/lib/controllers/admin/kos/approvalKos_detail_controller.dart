import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/admin/kos/approvalKos_model.dart';

/// Controller untuk action admin pada approval kos.
/// Harus beneran update Supabase agar alasan reject persist setelah logout.
class ApprovalDetailController {
  final supabase = Supabase.instance.client;

  /// Mengambil detail approval dari data (placeholder saat ini).
  /// Catatan: tetap dummy seperti sebelumnya.
  Future<ApprovalDetailModel?> getApprovalDetail(ApprovalModel approval) async {
    // Ambil data dari Supabase agar field seperti alasan_tolak persist setelah logout.
    final kostId = approval.id;

    final response = await supabase
        .from('kost')
        .select(
          'id_kost, nama_pemilik, no_hp_pemilik, email_pemilik, alamat, deskripsi, status, alasan_tolak, foto1_url, foto2_url, foto3_url, nama_kost',
        )
        .eq('id_kost', int.tryParse(kostId) ?? kostId)
        .maybeSingle();

    if (response == null) return null;

    // Helper baca value aman (hindari crash kalau kolom belum ada / null)
    String readString(dynamic v) => (v ?? '').toString();

    return ApprovalDetailModel(
      ownerName: readString(response['nama_pemilik']) == ''
          ? approval.name
          : readString(response['nama_pemilik']),
      ownerRole: 'Kost Owner',
      status: readString(response['status']) == ''
          ? approval.status
          : readString(response['status']),
      profileImage:
          approval.imageUrl, // belum ada kolom foto profil di query ini
      businessName: readString(response['nama_kost']) == ''
          ? approval.propertyName
          : readString(response['nama_kost']),
      phoneNumber: readString(response['no_hp_pemilik']) == ''
          ? '081234567890'
          : readString(response['no_hp_pemilik']),
      email: readString(response['email_pemilik']) == ''
          ? 'owner@example.com'
          : readString(response['email_pemilik']),
      address: readString(response['alamat']) == ''
          ? 'Jl. Mawar No. 123, Blitar, Jawa Timur'
          : readString(response['alamat']),
      description: readString(response['deskripsi']) == ''
          ? 'Kost nyaman, bersih, dan strategis dekat kampus serta fasilitas umum.'
          : readString(response['deskripsi']),
      photos: [
        readString(response['foto1_url']) != ''
            ? readString(response['foto1_url'])
            : approval.imageUrl,
        readString(response['foto2_url']) != ''
            ? readString(response['foto2_url'])
            : approval.imageUrl,
        readString(response['foto3_url']) != ''
            ? readString(response['foto3_url'])
            : approval.imageUrl,
      ],
      rejectionReason: (response['alasan_tolak'] == null)
          ? null
          : response['alasan_tolak'].toString(),
    );
  }

  /// Approve: set status menjadi aktif. Tidak perlu alasan.
  Future<void> approveKost(String kostId) async {
    await supabase
        .from('kost')
        .update({
          'status': 'aktif',
          // opsi: bersihkan alasan (kalau kolomnya nullable)
          'alasan_tolak': null,
        })
        .eq('id_kost', int.tryParse(kostId) ?? kostId);
  }

  /// Reject: set status menjadi ditolak dan simpan alasan_tolak.
  Future<void> rejectKost(String kostId, String rejectionReason) async {
    final reason = rejectionReason.trim();
    if (reason.isEmpty) {
      throw Exception('Alasan menolak wajib diisi.');
    }

    await supabase
        .from('kost')
        .update({'status': 'ditolak', 'alasan_tolak': reason})
        .eq('id_kost', int.tryParse(kostId) ?? kostId);
  }
}
