import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikJasa/vehicle_model.dart';
import '../../../views/pemilikJasa/home/tambahKendaraan_view.dart';
import '../../../views/pemilikJasa/home/editKendaraan_view.dart';
import '../../../controllers/pemilikJasa/detail_jasa_controller.dart';
import 'bottom_navbar.dart';

class PemilikJasaHomeFrame extends StatefulWidget {
  final String ownerName; // ← tambah
  final int totalVehicles;
  final int availableVehicles;
  final String totalIncome;
  final int newBookings;
  final String availableRatio;
  final List<OwnerVehicle> vehicles;
  final Function(int)? onNavigate;
  final VoidCallback? onRefresh; // ← tambah
  final Future<void> Function(String)? onDeleteJasa; // ← tambah

  const PemilikJasaHomeFrame({
    super.key,
    required this.ownerName, // ← tambah
    required this.totalVehicles,
    required this.availableVehicles,
    required this.totalIncome,
    required this.newBookings,
    required this.availableRatio,
    required this.vehicles,
    this.onNavigate,
    this.onRefresh,
    this.onDeleteJasa,
  });

  @override
  State<PemilikJasaHomeFrame> createState() => _PemilikJasaHomeFrameState();
}

class _PemilikJasaHomeFrameState extends State<PemilikJasaHomeFrame> {
  String _searchQuery = '';

  List<OwnerVehicle> get _filteredVehicles {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return widget.vehicles;

    return widget.vehicles.where((v) {
      final name = v.name.toLowerCase();
      final address = v.address.toLowerCase();
      final status = v.status.toLowerCase();
      return name.contains(q) || address.contains(q) || status.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            PemilikJasaHeader(
              ownerName: widget.ownerName, // ← tambah
              totalVehicles: widget.totalVehicles,
              availableVehicles: widget.availableVehicles,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 104),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PemilikJasaSearchPanel(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    const _SectionTitle('Ringkasan Bulan Ini'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.paid_outlined,
                            iconColor: AppColors.yellow,
                            title: 'Total Pendapatan',
                            value: widget.totalIncome,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.calendar_month_rounded,
                            iconColor: const Color(0xFF4D82FF),
                            title: 'Booking Baru',
                            value: '${widget.newBookings}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.local_shipping_rounded,
                            iconColor: const Color(0xFF31B75D),
                            title: 'Kendaraan Available',
                            value: widget.availableRatio,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const _SectionTitle('List of Your Vehicle'),
                    const SizedBox(height: 12),
                    if (_filteredVehicles.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          'Tidak ada kendaraan ditemukan',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    else
                      for (final vehicle in _filteredVehicles) ...[
                        OwnerVehicleCard(
                          vehicle: vehicle,
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/pemilik_jasa/detail_jasa',
                              arguments: vehicle.idJasa, // ← ganti dari vehicle.name
                            );
                          },
                          onEdit: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditKendaraanView(
                                  idJasa: vehicle.idJasa, // ← kirim idJasa
                                ),
                              ),
                            );
                            if (result == true) {
                              widget.onRefresh?.call();
                            }
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: Text(
                                  'Apakah Anda yakin ingin menghapus ${vehicle.name}? Data yang dihapus tidak dapat dikembalikan.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      try {
                                        await widget.onDeleteJasa
                                            ?.call(vehicle.idJasa);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${vehicle.name} berhasil dihapus',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Gagal hapus: $e'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PemilikJasaBottomNav(onNavigate: widget.onNavigate),
        ),
      ],
    );
  }
}

class PemilikJasaHeader extends StatelessWidget {
  final String ownerName; // ← tambah
  final int totalVehicles;
  final int availableVehicles;

  const PemilikJasaHeader({
    super.key,
    required this.ownerName, // ← tambah
    required this.totalVehicles,
    required this.availableVehicles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/pemilik_jasa/profile'),
                borderRadius: BorderRadius.circular(999),
                child: CircleAvatar(
                  radius: 22,
                  child: ClipOval(
                    child: Image(
                      image: const NetworkImage(
                        'https://i.pravatar.cc/120?img=12',
                      ),
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo-easylive.png',
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $ownerName', // ← dari Supabase
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text.rich(
                      TextSpan(
                        text: 'Welcome to ',
                        children: [
                          TextSpan(
                            text: 'EasyLive !',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/pemilik_jasa/notifikasi'),
                borderRadius: BorderRadius.circular(18),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: _NotificationBell(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  icon: Icons.door_sliding_outlined,
                  title: 'Total Kendaraan',
                  value: '$totalVehicles Kendaraan',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _HeaderStat(
                  icon: Icons.hotel_rounded,
                  title: 'Kendaraan Tersedia',
                  value: '$availableVehicles Kendaraan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PemilikJasaSearchPanel extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const PemilikJasaSearchPanel({super.key, this.onChanged});

  @override
  State<PemilikJasaSearchPanel> createState() => _PemilikJasaSearchPanelState();
}

class _PemilikJasaSearchPanelState extends State<PemilikJasaSearchPanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              hintText: 'Search....',
              hintStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.black45,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.darkBlue,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.darkBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahKendaraanView(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded, size: 23),
            label: const Text('Tambah Kendaraan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.darkBlue,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerVehicleCard extends StatelessWidget {
  final OwnerVehicle vehicle;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const OwnerVehicleCard({
    super.key,
    required this.vehicle,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 126,
              height: 88,
              // ← gambar dynamic: network atau asset
              child: vehicle.isNetworkImage
                  ? Image.network(
                      vehicle.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/pickup-removed.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(vehicle.image, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
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
                      _StatusBadge(
                        label: vehicle.status,
                        color: vehicle.statusColor,
                      ),
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
                          vehicle.address,
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
                        icon: Icons.inventory_2_outlined,
                        label: vehicle.capacity,
                        color: Colors.black54,
                      ),
                      _MiniInfo(
                        icon: Icons.circle,
                        label: vehicle.availability,
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
                    vehicle.income,
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
            Column(
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: onEdit,
                ),
                const SizedBox(height: 6),
                _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Hapus',
                  color: AppColors.red,
                  onTap: onDelete,
                ),
                const SizedBox(height: 6),
                _ActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'Detail',
                  onTap: onDetail,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.notifications_none_rounded,
          color: Colors.white,
          size: 31,
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.yellow,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '5',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _HeaderStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF243446),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.yellow, size: 26),
        ),
        const SizedBox(width: 9),
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
                  fontSize: 8,
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
                  fontSize: 11,
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

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 75),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 6),
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
                        fontSize: 6.8,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.darkBlue,
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
        color: color.withValues(alpha: 0.13),
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
              fontSize: 7,
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
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color = AppColors.darkBlue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 56,
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
                fontSize: 7,
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