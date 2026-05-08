import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikJasa/dashboard_model.dart';

class PemilikJasaDashboardHeader extends StatelessWidget {
  final String ownerName;
  final int notificationCount;
  final List<JasaDashboardStat> stats;

  const PemilikJasaDashboardHeader({
    super.key,
    required this.ownerName,
    required this.notificationCount,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/120?img=12',
                ),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _NotificationBell(count: notificationCount),
            ],
          ),
          const SizedBox(height: 18),
          _StatRow(items: stats.take(2).toList()),
          const SizedBox(height: 12),
          _StatRow(items: stats.skip(2).take(2).toList()),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<JasaDashboardStat> items;

  const _StatRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < items.length; index++) ...[
          Expanded(child: _DashboardStatItem(stat: items[index])),
          if (index != items.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _DashboardStatItem extends StatelessWidget {
  final JasaDashboardStat stat;

  const _DashboardStatItem({required this.stat});

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
          child: Icon(stat.icon, color: stat.color, size: 25),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 8,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Lihat semua',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 7,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;

  const _NotificationBell({required this.count});

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
            child: Text(
              '$count',
              style: const TextStyle(
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
