import 'package:flutter/material';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../screens/auth_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import 'settings_modal.dart';
import 'model_selector_modal.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    return Drawer(
      backgroundColor: AppTheme.bgDark,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with User Profile (Clickable to open Profile Screen)
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.primaryNeon.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    const AppLogo(size: 44, showGlow: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            currentUser?.name ?? 'ZUNO AI',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          Text(
                            currentUser != null
                                ? '@${currentUser.username}'
                                : 'by zzamcode',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.secondaryNeon,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
                  ],
                ),
              ),
            ),

            // New Chat Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryNeon,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  provider.createNewSession(userId: currentUser?.id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  'Percakapan Baru',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Riwayat Obrolan',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            // Chat History List
            Expanded(
              child: ListView.builder(
                itemCount: provider.sessions.length,
                itemBuilder: (context, index) {
                  final session = provider.sessions[index];
                  final isSelected = session.id == provider.currentSessionId;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.surfaceDark : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: AppTheme.secondaryNeon.withOpacity(0.5))
                          : null,
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: isSelected ? AppTheme.secondaryNeon : AppTheme.textMuted,
                        size: 20,
                      ),
                      title: Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textMuted,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppTheme.accentPink, size: 18),
                              onPressed: () {
                                provider.deleteSession(session.id, userId: currentUser?.id);
                              },
                            )
                          : null,
                      onTap: () {
                        provider.selectSession(session.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),

            const Divider(color: AppTheme.surfaceDark),

            // Model Switcher Option
            ListTile(
              leading: const Icon(Icons.psychology_outlined, color: AppTheme.secondaryNeon),
              title: const Text('Pilih Model AI', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                provider.selectedModel,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ModelSelectorModal(),
                );
              },
            ),

            // Profile ListTile
            ListTile(
              leading: const Icon(Icons.person_outline_rounded, color: AppTheme.secondaryNeon),
              title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),

            // Settings ListTile
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: AppTheme.secondaryNeon),
              title: const Text('Pengaturan Server', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            // Logout ListTile
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppTheme.accentPink),
              title: const Text('Keluar (Logout)', style: TextStyle(color: AppTheme.accentPink)),
              onTap: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
