import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Modern status badge with color coding
class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  Color get _color {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
      case 'paid':
      case 'approved':
      case 'active':
      case 'confirmed':
        return AppTheme.success;
      case 'pending':
      case 'processing':
      case 'in_progress':
      case 'sent':
        return AppTheme.warning;
      case 'cancelled':
      case 'rejected':
      case 'overdue':
      case 'voided':
      case 'failed':
        return AppTheme.error;
      case 'draft':
      case 'new':
      case 'open':
        return AppTheme.info;
      case 'shipped':
      case 'transferred':
        return AppTheme.secondary;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = status.replaceAll('_', ' ');
    final fontSize = isSmall ? 10.0 : 12.0;
    final horizontalPadding = isSmall ? 8.0 : 10.0;
    final verticalPadding = isSmall ? 3.0 : 5.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(
          color: _color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        displayText[0].toUpperCase() + displayText.substring(1),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: _color,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Section header with optional action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppTheme.textPrimary),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
