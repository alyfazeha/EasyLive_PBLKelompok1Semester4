import 'package:flutter/material.dart';

import '../../../core/color.dart';

class OwnerNotificationFilterTabs extends StatelessWidget {
  final bool showUnreadOnly;
  final int totalCount;
  final int unreadCount;
  final VoidCallback onShowAll;
  final VoidCallback onShowUnread;

  const OwnerNotificationFilterTabs({
    super.key,
    required this.showUnreadOnly,
    required this.totalCount,
    required this.unreadCount,
    required this.onShowAll,
    required this.onShowUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NotificationFilterChip(
          label: 'Semua ($totalCount)',
          selected: !showUnreadOnly,
          onTap: onShowAll,
        ),
        const SizedBox(width: 10),
        _NotificationFilterChip(
          label: 'Belum Dibaca ($unreadCount)',
          selected: showUnreadOnly,
          onTap: onShowUnread,
        ),
      ],
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NotificationFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lightGrey : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.darkBlue : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}
