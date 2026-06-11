import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/homeKos_controller.dart';
import '../../../views/pemilikKos/home/editKamar_view.dart';
import 'bottom_navbar.dart';
import 'owner_search_section.dart';

class OwnerDashboardFrame extends StatefulWidget {
  final Function(int)? onNavigate;

  const OwnerDashboardFrame({super.key, this.onNavigate});

  @override
  State<OwnerDashboardFrame> createState() => _OwnerDashboardFrameState();
}

class _OwnerDashboardFrameState extends State<OwnerDashboardFrame> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Column(
            children: [
              const OwnerHeaderSection(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 104),
                  child: OwnerDashboardContent(
                    searchQuery: _searchQuery,
                    onSearchChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: OwnerBottomNav(onNavigate: widget.onNavigate),
          ),
        ],
      ),
    );
  }
}

class OwnerDashboardContent extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const OwnerDashboardContent({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PemilikKosController>();
    final hasPhoto = controller.model?.userImage?.isNotEmpty == true &&
      controller.model!.userImage!.startsWith('http');
    final model = controller.model;
    final kostList = model?.kostList ?? [];

    final normalizedQuery = searchQuery.trim().toLowerCase();
    final filteredKos = normalizedQuery.isEmpty
        ? kostList
        : kostList
              .where(
                (k) =>
                    k.name.toLowerCase().contains(normalizedQuery) ||
                    k.status.toLowerCase().contains(normalizedQuery) ||
                    k.alamat.toLowerCase().contains(normalizedQuery) ||
                    k.emptyRoom.toLowerCase().contains(normalizedQuery),
              )
              .toList();

    final occupiedRooms = model?.occupiedRooms ?? 0;
    final totalRooms = model?.totalRooms ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OwnerSearchSection(onChanged: onSearchChanged),
        const SizedBox(height: 16),
        const Text(
          'Ringkasan Bulan Ini',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.payments_rounded,
                iconColor: AppColors.yellow,
                title: 'Total Pendapatan',
                value: 'Rp ${_formatHarga(model?.totalIncome ?? 0)}',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.calendar_month_rounded,
                iconColor: Color(0xFF4D82FF),
                title: 'Booking Baru',
                value: '${model?.newBookings ?? 0}', // ← dari Supabase
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.bed_rounded,
                iconColor: Color(0xFF31B75D),
                title: 'Kamar Terisi',
                value: '$occupiedRooms / $totalRooms',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'List of Your Kost',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 12),

        if (controller.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (filteredKos.isEmpty)
          const _EmptyKosSearchResult()
        else
          ...filteredKos.expand(
            (kos) => [
              OwnerKosCard(
                imageWidget: kos.imageWidget,
                name: kos.name,
                idKost: kos.idKost,
                price: kos.price,
                status: kos.status,
                statusColor: kos.statusColorValue,
                emptyRoom: kos.emptyRoom,
                jumlahKamar: kos.jumlahKamar,
                alamat: kos.alamat,
              ),
              const SizedBox(height: 14),
            ],
          ),
      ],
    );
  }
}

class _EmptyKosSearchResult extends StatelessWidget {
  const _EmptyKosSearchResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: Colors.black38, size: 34),
          SizedBox(height: 8),
          Text(
            'Kost tidak ditemukan',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Coba kata kunci lain',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerHeaderSection extends StatelessWidget {
  const OwnerHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PemilikKosController>();
    final model = controller.model;
    final hasPhoto = model?.userImage?.isNotEmpty == true && model!.userImage.startsWith('http');
    final ownerName = model?.ownerName ?? 'Pemilik Kos';
    final totalKost = model?.totalKost ?? 0;
    final availableRooms = model?.availableRooms ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/pemilik_kos/profile');
                  },
                  borderRadius: BorderRadius.circular(50),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: AppColors.yellow,
                          backgroundImage: hasPhoto
                              ? NetworkImage(controller.model!.userImage!)
                              : null,
                          onBackgroundImageError: hasPhoto ? (_, __) {} : null,
                          child: !hasPhoto
                              ? const Icon(
                                  Icons.person_rounded,
                                  color: AppColors.darkBlue,
                                  size: 28,
                                )
                              : null,
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, $ownerName',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                text: 'Welcome to ',
                                children: const [
                                  TextSpan(
                                    text: 'EasyLive !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const _NotificationBell(),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OwnerHeaderStat(
                  icon: Icons.meeting_room_outlined,
                  title: 'Total Kost',
                  value: '$totalKost Kost',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: OwnerHeaderStat(
                  icon: Icons.bed_rounded,
                  title: 'Kamar Tersedia',
                  value: '$availableRooms Kamar',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/pemilik_kos/notifikasi'),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class OwnerHeaderStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const OwnerHeaderStat({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF243446),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.yellow, size: 27),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OwnerSectionTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const OwnerSectionTitle({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: AppColors.yellow,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class OwnerSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const OwnerSummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 7.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class OwnerKosCard extends StatelessWidget {
  final Widget imageWidget;
  final String name;
  final String price;
  final String idKost;
  final String status;
  final Color statusColor;
  final String emptyRoom;
  final String alamat;
  final int jumlahKamar;

  const OwnerKosCard({
    super.key,
    required this.imageWidget,
    required this.name,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.idKost,
    required this.emptyRoom,
    required this.alamat,
    required this.jumlahKamar,
  });

  @override
  Widget build(BuildContext context) {
    void openDetail() {
      Navigator.pushNamed(
        context,
        '/pemilik_kos/detail_kamar',
        arguments: idKost,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: openDetail,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                        _StatusBadge(label: status, color: statusColor),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: Colors.black38,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            alamat,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 7.5,
                              color: Colors.black38,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _MiniInfo(
                          icon: Icons.bed_rounded,
                          label: '$jumlahKamar Kamar',
                          color: Colors.black54,
                        ),
                        _MiniInfo(
                          icon: Icons.circle,
                          label: emptyRoom,
                          color: const Color(0xFF31B75D),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pendapatan',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 7.5,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              // Bikin kolom tombol punya lebar tetap supaya Row tidak overflow
              SizedBox(
                width: 58,
                child: Column(
                  children: [
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditKamarView(idKost: idKost), // ← kirim idKost
                          ),
                        );
                        // Refresh home kalau edit berhasil
                        if (result == true && context.mounted) {
                          context.read<PemilikKosController>().refresh();
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Hapus',
                      color: AppColors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              "Hapus Kost?",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                color: const Color.fromRGBO(45, 62, 80, 1),
                              ),
                            ),
                            content: Text(
                              "Apakah Anda yakin ingin menghapus kost ini? Data yang dihapus tidak dapat dikembalikan.",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  "Batal",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(ctx); // tutup dialog dulu

                                  try {
                                    // Panggil deleteKost dari controller
                                    await context
                                        .read<PemilikKosController>()
                                        .deleteKost(
                                          idKost,
                                        ); // ← idKost dari parameter card

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Kost berhasil dihapus"),
                                        backgroundColor: AppColors.darkBlue,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Gagal menghapus kost: $e"),
                                        backgroundColor: AppColors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Hapus",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    _ActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'Detail',
                      onTap: openDetail,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniInfo({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: icon == Icons.circle ? 6 : 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 7.5,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.darkBlue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 58,
        height: 25,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 7.5,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tambah di luar class, di bagian bawah dashboard_widgets.dart
String _formatHarga(double harga) {
  return harga.toInt().toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
}
