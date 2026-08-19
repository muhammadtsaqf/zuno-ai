import 'package:flutter/material';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_poster_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Profil Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.cardDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryNeon, AppTheme.secondaryNeon],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryNeon.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                  const AppLogo(size: 110, showGlow: false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Pengguna Zuno',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@${user?.username ?? 'username'}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryNeon,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            // Profile Card Details
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surfaceDark),
              ),
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Nama Lengkap',
                    subtitle: user?.name ?? '-',
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 1),
                  _buildProfileTile(
                    icon: Icons.alternate_email,
                    title: 'Username',
                    subtitle: '@${user?.username ?? '-'}',
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 1),
                  _buildProfileTile(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    subtitle: user?.email ?? '-',
                  ),
                  const Divider(color: AppTheme.surfaceDark, height: 1),
                  _buildProfileTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Status Akun',
                    subtitle: 'Terverifikasi • Terhubung Cloud Encrypted Server',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Promotional Cyber Banner Poster Widget
            const AppPosterBanner(),

            const SizedBox(height: 24),

            // Plan / Badge Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryNeon.withOpacity(0.2),
                    AppTheme.secondaryNeon.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.secondaryNeon.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium, color: AppTheme.secondaryNeon, size: 30),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zuno AI Pro Access',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Akses tanpa batas ke Qwen, Gemini, & Claude Sonnet/Opus.',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryNeon),
      title: Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
