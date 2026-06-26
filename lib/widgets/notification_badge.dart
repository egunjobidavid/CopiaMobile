import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final Color color;

  const NotificationBadge({
    super.key,
    required this.count,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class NotificationBadgeIcon extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const NotificationBadgeIcon({super.key, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: NotificationBadge(count: count),
          ),
      ],
    );
  }
}
