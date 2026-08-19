import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/version_service.dart';
import '../widgets/force_update_dialog.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkVersionAndNavigate();
  }

  void _checkVersionAndNavigate() async {
    final versionInfo = await VersionService.checkUpdate();
    
    // Check if update is required
    bool isUpdateRequired = false;
    if (versionInfo != null) {
      final int minCompare = VersionService.compareVersions(
        AppConfig.appVersion,
        versionInfo.minRequiredVersion,
      );
      if (minCompare < 0 || versionInfo.forceUpdate) {
        isUpdateRequired = true;
      }
    }

    if (mounted) {
      if (isUpdateRequired && versionInfo != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ForceUpdateDialog(versionInfo: versionInfo),
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final Widget targetScreen = authProvider.isAuthenticated
            ? const HomeScreen()
            : const AuthScreen();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: targetScreen,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Stack(
        children: [
          // Background Gradient Glow Accent
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryNeon.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryNeon.withOpacity(0.2),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryNeon.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondaryNeon.withOpacity(0.15),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // Main Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZoomIn(
                  duration: const Duration(milliseconds: 1200),
                  child: Pulse(
                    infinite: true,
                    duration: const Duration(seconds: 3),
                    child: const AppLogo(size: 140),
                  ),
                ),
                const SizedBox(height: 30),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 800),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppTheme.secondaryNeon,
                        Colors.white,
                        AppTheme.primaryNeon,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'ZUNO AI',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.secondaryNeon.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Next-Gen Multi-Model AI Assistant',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryNeon,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Developer Branding
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeIn(
              delay: const Duration(milliseconds: 1400),
              child: Column(
                children: [
                  Text(
                    'POWERED BY',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2.0,
                      color: AppTheme.textMuted.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'zzamcode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Muhammad Tsaqif Noor Az Zamil',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
