import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class PosSuccessScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final int itemCount;

  const PosSuccessScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
    required this.itemCount,
  });

  @override
  State<PosSuccessScreen> createState() => _PosSuccessScreenState();
}

class _PosSuccessScreenState extends State<PosSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _paymentMethodLabel {
    switch (widget.paymentMethod) {
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      case 'transfer':
        return 'Transfer';
      default:
        return widget.paymentMethod;
    }
  }

  IconData get _paymentMethodIcon {
    switch (widget.paymentMethod) {
      case 'cash':
        return Icons.money_rounded;
      case 'card':
        return Icons.credit_card_rounded;
      case 'transfer':
        return Icons.account_balance_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.success, Color(0xFF27AE60)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.success.withOpacity(0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: const Text(
                    'Sale Complete!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    'Transaction processed successfully',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border, width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_paymentMethodIcon, color: AppTheme.primary, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                _paymentMethodLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₦${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.itemCount} item${widget.itemCount == 1 ? '' : 's'} sold',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                SlideTransition(
                  position: _slideAnim,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'New Sale',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SlideTransition(
                  position: _slideAnim,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: const BorderSide(color: AppTheme.border, width: 1.5),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
