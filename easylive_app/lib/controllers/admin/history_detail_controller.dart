import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/admin/history_detail_model.dart';
import '../../models/admin/history_model.dart';

class AdminHistoryDetailController {
  final HistoryItemModel historyItem;
  final supabase = Supabase.instance.client;

  AdminHistoryDetailController({required this.historyItem});

  Future<AdminHistoryDetailModel> loadDetail() async {
    try {
      if (historyItem.type == 'kos') {
        return await _loadKosDetail();
      } else {
        return await _loadJasaDetail();
      }
    } catch (e) {
      debugPrint('Error loading history detail: $e');
      return _fallback();
    }
  }

  Future<AdminHistoryDetailModel> _loadKosDetail() async {
    final res = await supabase
        .from('kost')
        .select('id_kost, nama_kost, status, alasan_tolak, profiles!inner(username, full_name)')
        .eq('id_kost', int.parse(historyItem.id))
        .single();

    final status = res['status'] as String;
    final namaKost = res['nama_kost'] ?? '-';
    final alasan = res['alasan_tolak'] as String?;
    final profile = res['profiles'] as Map<String, dynamic>?;
    final fullName = (profile?['full_name'] ?? '').toString();
    final username = (profile?['username'] ?? '').toString();
    final ownerName = fullName.isNotEmpty ? fullName : username;

    final type = status == 'aktif'
        ? AdminHistoryType.kosApproved
        : AdminHistoryType.kosRejected;

    return AdminHistoryDetailModel(
      title: status == 'aktif'
          ? 'Kos "$namaKost" disetujui'
          : 'Kos "$namaKost" ditolak',
      subtitle: 'Pemilik: $ownerName',
      date: '-',
      type: type,
      pihak: ownerName,
      kategori: 'Kos',
      objek: namaKost,
      status: status == 'aktif' ? 'Disetujui' : 'Ditolak',
      alasanPenolakan: alasan,
      idDokumen: res['id_kost'].toString(),
      icon: status == 'aktif'
          ? Icons.check_circle_rounded
          : Icons.cancel_rounded,
      iconColor: status == 'aktif'
          ? const Color(0xFF0C7A3D)
          : const Color(0xFFE4251B),
    );
  }

  Future<AdminHistoryDetailModel> _loadJasaDetail() async {
    final res = await supabase
        .from('jasa')
        .select('id_jasa, nama_jasa, status, tipe_mobil, alamat, profiles!inner(username, full_name)')
        .eq('id_jasa', int.parse(historyItem.id))
        .single();

    final status = res['status'] as String;
    final namaJasa = res['nama_jasa'] ?? '-';
    final profile = res['profiles'] as Map<String, dynamic>?;
    final fullName = (profile?['full_name'] ?? '').toString();
    final username = (profile?['username'] ?? '').toString();
    final ownerName = fullName.isNotEmpty ? fullName : username;

    final type = status == 'aktif'
        ? AdminHistoryType.jasaApproved
        : AdminHistoryType.jasaRejected;

    return AdminHistoryDetailModel(
      title: status == 'aktif'
          ? 'Jasa "$namaJasa" disetujui'
          : 'Jasa "$namaJasa" ditolak',
      subtitle: 'Pemilik: $ownerName',
      date: '-',
      type: type,
      pihak: ownerName,
      kategori: 'Jasa',
      objek: namaJasa,
      status: status == 'aktif' ? 'Disetujui' : 'Ditolak',
      alasanPenolakan: null,
      idDokumen: res['id_jasa'].toString(),
      icon: status == 'aktif'
          ? Icons.check_circle_rounded
          : Icons.cancel_rounded,
      iconColor: status == 'aktif'
          ? const Color(0xFF0C7A3D)
          : const Color(0xFFE4251B),
    );
  }

  AdminHistoryDetailModel _fallback() {
    return AdminHistoryDetailModel(
      title: historyItem.title,
      subtitle: historyItem.subtitle,
      date: historyItem.date,
      type: AdminHistoryType.laporanCreated,
      pihak: '-',
      kategori: historyItem.type,
      objek: '-',
      status: historyItem.status,
      alasanPenolakan: null,
      idDokumen: null,
      icon: Icons.info_outline,
      iconColor: const Color(0xFF2F80ED),
    );
  }
}