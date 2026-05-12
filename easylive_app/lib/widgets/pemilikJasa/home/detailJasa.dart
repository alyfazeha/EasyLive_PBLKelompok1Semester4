import 'package:flutter/material.dart';

import '../../../models/pemilikJasa/detail_jasa_model.dart';


class DetailJasaWidget extends StatelessWidget {
  final DetailJasa jasa;

  const DetailJasaWidget({super.key, required this.jasa});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _InfoTitle('Penyewa / Customer'),
            // Model DetailJasa saat ini belum menyimpan nama customer
            const _InfoValue('-'),
            const SizedBox(height: 12),

            const _InfoTitle('Kendaraan'),
            _InfoValue(jasa.name),
            const SizedBox(height: 12),

            const _InfoTitle('Lokasi'),
            _InfoValue(jasa.address),
            const SizedBox(height: 12),

            const _InfoTitle('Tanggal'),
            const _InfoValue('-'),
            const SizedBox(height: 12),

            const _InfoTitle('Total'),
            _InfoValue(jasa.price),
            const SizedBox(height: 12),

            const _InfoTitle('Status'),
            const _InfoValue('-'),
            const SizedBox(height: 12),

            // Tambahan agar detail tetap informatif (tanpa menghilangkan konten)
            const SizedBox(height: 8),
            const _InfoTitle('Deskripsi'),
            _InfoValue(jasa.description),
            const SizedBox(height: 12),

            const _InfoTitle('Spesifikasi'),
            _InfoValue(jasa.specifications.join(', ')),
          ],
        ),
      ),
    );
  }
}

class _InfoTitle extends StatelessWidget {
  final String title;

  const _InfoTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.black54,
      ),
    );
  }
}

class _InfoValue extends StatelessWidget {
  final String value;

  const _InfoValue(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}

