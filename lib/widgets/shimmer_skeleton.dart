import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Reusable shimmer skeleton widget with pulse animation.
class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();

  // Convenience constructors
  static Widget card({double? height}) {
    return _SkeletonCard(height: height);
  }

  static Widget circle({double size = 40}) {
    return _SkeletonCircle(size: size);
  }

  static Widget text({double width = 120}) {
    return ShimmerSkeleton(width: width, height: 14);
  }

  static Widget listTile() {
    return const _SkeletonListTile();
  }

  static Widget kpiCard() {
    return _SkeletonKpiCard();
  }
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              widget.baseColor ?? Colors.grey.shade200,
              widget.highlightColor ?? Colors.grey.shade100,
              _animation.value,
            ),
          ),
        );
      },
    );
  }
}

// Pre-built skeleton layouts

class _SkeletonCard extends StatelessWidget {
  final double? height;
  const _SkeletonCard({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(width: 80, height: 14),
          const SizedBox(height: 12),
          ShimmerSkeleton(width: 60, height: 24),
        ],
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;
  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

class _SkeletonListTile extends StatelessWidget {
  const _SkeletonListTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ShimmerSkeleton.circle(size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(width: 140, height: 14),
                const SizedBox(height: 6),
                ShimmerSkeleton(width: 100, height: 12),
              ],
            ),
          ),
          ShimmerSkeleton(width: 60, height: 14),
        ],
      ),
    );
  }
}

class _SkeletonKpiCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(width: 60, height: 12, baseColor: Colors.white30, highlightColor: Colors.white54),
          const SizedBox(height: 8),
          ShimmerSkeleton(width: 80, height: 22, baseColor: Colors.white30, highlightColor: Colors.white54),
        ],
      ),
    );
  }
}

/// Dashboard-specific skeleton for the full dashboard loading state.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // KPI row
        Row(
          children: [
            Expanded(child: ShimmerSkeleton.kpiCard()),
            const SizedBox(width: 12),
            Expanded(child: ShimmerSkeleton.kpiCard()),
          ],
        ),
        const SizedBox(height: 20),
        // Quick actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (_) => ShimmerSkeleton.circle(size: 56)),
        ),
        const SizedBox(height: 28),
        // Activity list
        ...List.generate(3, (_) => const _SkeletonListTile()),
      ],
    );
  }
}
