import 'package:flutter/material.dart';

class AdminActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  const AdminActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF243447).withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.timeline_rounded,
          color: Color(0xFF243447),
          size: 18,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Color(0xFF243447),
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black45,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.black38,
        ),
      ),
    );
  }
}
