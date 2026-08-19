import 'package:flutter/material';
import 'app_logo.dart';
import '../theme/app_theme.dart';

/// Cyberpunk Metallic App Icon Badge Widget
class AppIconBadge extends StatelessWidget {
  final double size;
  final bool showGlow;

  const AppIconBadge({
    super.key,
    this.size = 80,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.15),
      decoration: BoxDecoration(
        color: AppTheme.bgDark,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppTheme.primaryNeon.withOpacity(0.4),
                  blurRadius: size * 0.3,
                  spreadRadius: size * 0.05,
                ),
                BoxShadow(
                  color: AppTheme.secondaryNeon.withOpacity(0.3),
                  blurRadius: size * 0.5,
                  spreadRadius: size * 0.02,
                )
              ]
            : null,
        border: Border.all(
          color: AppTheme.secondaryNeon.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: AppLogo(size: size * 0.7, showGlow: false),
    );
  }
}

/// Promotional Cyber Poster Banner Widget
class AppPosterBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const AppPosterBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1035), Color(0xFF0D061A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryNeon.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryNeon.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              children: [
                const AppIconBadge(size: 48, showGlow: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'ZUNO AI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentPink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.accentPink, width: 1),
                            ),
                            child: const Text(
                              'PRO 1.0',
                              style: TextStyle(
                                color: AppTheme.accentPink,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Advanced Multi-Engine AI Assistant',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryNeon,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Powered by Qwen Max 3.8, Gemini 3.6 Flash, & Claude 4.6 dengan dukungan Cloud Encrypted Session Sync.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildBadge('Qwen Max 3.8', AppTheme.primaryNeon),
                const SizedBox(width: 8),
                _buildBadge('Gemini 3.6', AppTheme.secondaryNeon),
                const SizedBox(width: 8),
                _buildBadge('Claude 4.6', AppTheme.accentPink),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
