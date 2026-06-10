// controllers/admin/approval_jasa_controller.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/admin/approval_jasa_model.dart';

class ApprovalJasaController {
  final SupabaseClient supabase = Supabase.instance.client;

  // ─── LIST ──────────────────────────────────────────────────────────────────

  /// Mengambil semua data jasa dengan filter status opsional.
  /// [statusFilter] bisa berisi: 'pending', 'aktif', 'ditolak', atau null (semua).
  Future<List<ApprovalJasaModel>> getJasaList({
    String? statusFilter,
  }) async {
    try {
      var query = supabase.from('jasa').select('''
        id_jasa,
        nama_jasa,
        tipe_mobil,
        gambar,
        status,
        alamat,
        kecamatan,
        kota,
        nomor_hp,
        nomor_plat,
        kapasitas,
        deskripsi,
        owner:profiles!owner_id (
          full_name,
          email,
          photo
        )
      ''');

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.eq('status', statusFilter);
      }

      final response = await query.order('id_jasa', ascending: false);

      return (response as List<dynamic>)
          .map((item) =>
              ApprovalJasaModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getJasaList: $e');
      return [];
    }
  }

  // ─── DETAIL ────────────────────────────────────────────────────────────────

  /// Mengambil detail satu jasa berdasarkan id_jasa.
  Future<ApprovalJasaModel?> getJasaDetail(String idJasa) async {
    try {
      print('Fetching jasa id: $idJasa');

      final response = await supabase
          .from('jasa')
          .select('''
            id_jasa,
            nama_jasa,
            tipe_mobil,
            gambar,
            status,
            alamat,
            kecamatan,
            kota,
            nomor_hp,
            nomor_plat,
            kapasitas,
            deskripsi,
            owner:profiles!owner_id (
              full_name,
              email,
              photo
            )
          ''')
          .eq('id_jasa', idJasa)
          .single();

      return ApprovalJasaModel.fromMap(response);
    } catch (e) {
      print('Error getJasaDetail: $e');
      return null;
    }
  }

  // ─── APPROVE ───────────────────────────────────────────────────────────────

  /// Meng-approve jasa: set status = 'aktif' dan hapus alasan_tolak.
  Future<void> approveJasa(String idJasa) async {
    await supabase
        .from('jasa')
        .update({'status': 'aktif'})
        .eq('id_jasa', idJasa);
  }

  // ─── REJECT ────────────────────────────────────────────────────────────────

  /// Menolak jasa: set status = 'ditolak' dan simpan alasan_tolak.
  Future<void> rejectJasa(String idJasa, String rejectionReason) async {
    final reason = rejectionReason.trim();
    if (reason.isEmpty) {
      throw Exception('Alasan menolak wajib diisi.');
    }

    await supabase
        .from('jasa')
        .update({'status': 'ditolak'})
        .eq('id_jasa', idJasa);
  }
}