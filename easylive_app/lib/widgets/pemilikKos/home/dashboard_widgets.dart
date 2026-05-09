import 'package:flutter/material.dart';

import '../../../core/color.dart';
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

  static const List<_OwnerKosItem> _kosList = [
    _OwnerKosItem(
      image: 'assets/images/kos1.jpg',
      name: 'Daniska Kos',
      price: 'Rp 1.500.000 / bulan',
      status: 'Aktif',
      statusColor: Color(0xFF31B75D),
      emptyRoom: '1 Kosong',
      location: 'Jalan Cengger Ayam Dalam III, Lowokwaru Malang',
    ),
    _OwnerKosItem(
      image: 'assets/images/kos2.jpg',
      name: 'Triple A',
      price: 'Rp 900.000 / bulan',
      status: 'Penuh',
      statusColor: AppColors.red,
      emptyRoom: '5 Kosong',
      location: 'Jalan Cengger Ayam Dalam III, Lowokwaru Malang',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final filteredKos = normalizedQuery.isEmpty
        ? _kosList
        : _kosList.where((kos) => kos.matches(normalizedQuery)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OwnerSearchSection(onChanged: onSearchChanged),
        const SizedBox(height: 16),
        OwnerSectionTitle(
          title: 'Ringkasan Bulan Ini',
          actionText: 'Lihat Detail',
          onActionTap: () {},
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.payments_rounded,
                iconColor: AppColors.yellow,
                title: 'Total Pendapatan',
                value: 'Rp 22.500.000',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.calendar_month_rounded,
                iconColor: Color(0xFF4D82FF),
                title: 'Booking Baru',
                value: '18',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OwnerSummaryCard(
                icon: Icons.bed_rounded,
                iconColor: Color(0xFF31B75D),
                title: 'Kamar Terisi',
                value: '30 / 50',
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
        if (filteredKos.isEmpty)
          const _EmptyKosSearchResult()
        else
          ...filteredKos.expand(
            (kos) => [
              OwnerKosCard(
                image: kos.image,
                name: kos.name,
                price: kos.price,
                status: kos.status,
                statusColor: kos.statusColor,
                emptyRoom: kos.emptyRoom,
              ),
              const SizedBox(height: 14),
            ],
          ),
      ],
    );
  }
}

class _OwnerKosItem {
  final String image;
  final String name;
  final String price;
  final String status;
  final Color statusColor;
  final String emptyRoom;
  final String location;

  const _OwnerKosItem({
    required this.image,
    required this.name,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.emptyRoom,
    required this.location,
  });

  bool matches(String query) {
    return name.toLowerCase().contains(query) ||
        price.toLowerCase().contains(query) ||
        status.toLowerCase().contains(query) ||
        emptyRoom.toLowerCase().contains(query) ||
        location.toLowerCase().contains(query);
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
          Icon(
            Icons.search_off_rounded,
            color: Colors.black38,
            size: 34,
          ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
      decoration: BoxDecoration(
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
              const CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.yellow,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.darkBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Rafi',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text.rich(
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
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const _NotificationBell(),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: OwnerHeaderStat(
                  icon: Icons.meeting_room_outlined,
                  title: 'Total Kost',
                  value: '5 Kost',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: OwnerHeaderStat(
                  icon: Icons.bed_rounded,
                  title: 'Kamar Tersedia',
                  value: '12 Kamar',
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
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(10),
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
          const Text(
            '+12% dari bulan lalu',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 7.5,
              color: Color(0xFF31B75D),
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerKosCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String status;
  final Color statusColor;
  final String emptyRoom;

  const OwnerKosCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.emptyRoom,
  });

  @override
  Widget build(BuildContext context) {
    void openDetail() {
      Navigator.pushNamed(context, '/pemilik_kos/detail_kamar');
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
                child: Image.asset(
                  image,
                  width: 140,
                  height: 88,
                  fit: BoxFit.cover,
                ),
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
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            'Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
                        const _MiniInfo(
                          icon: Icons.bed_rounded,
                          label: '30 Kamar',
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
              Column(
                children: [
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKamarView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: AppColors.red,
                    onTap: () {
                      // Show delete confirmation dialog
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "Hapus Kost?",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkBlue,
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
                              onPressed: () {
                                // Logika hapus kost di sini
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Kost berhasil dihapus"),
                                    backgroundColor: AppColors.darkBlue,
                                  ),
                                );
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
