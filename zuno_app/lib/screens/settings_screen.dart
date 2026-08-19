import 'package:flutter/material';
import 'package:provider/provider.dart';
import '../models/ai_models.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/settings_modal.dart';
import '../widgets/model_selector_modal.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Pengaturan App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.cardDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'MODEL & KECERDASAN',
            style: TextStyle(
              color: AppTheme.secondaryNeon,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceDark),
            ),
            child: ListTile(
              leading: const Icon(Icons.psychology_outlined, color: AppTheme.secondaryNeon),
              title: const Text('Default Model Engine', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                AiModels.getModelInfo(chatProvider.selectedModel).displayName,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ModelSelectorModal(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'KONEKSI & SERVER',
            style: TextStyle(
              color: AppTheme.secondaryNeon,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceDark),
            ),
            child: ListTile(
              leading: const Icon(Icons.dns_outlined, color: AppTheme.secondaryNeon),
              title: const Text('Server Backend URL Custom', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                chatProvider.vercelBackendUrl.isEmpty
                    ? 'Default Cloud Server (${AppConfig.defaultVercelBackendUrl})'
                    : chatProvider.vercelBackendUrl,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const SettingsModal(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'RIWAYAT CHAT & DATA',
            style: TextStyle(
              color: AppTheme.secondaryNeon,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceDark),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_sweep_outlined, color: AppTheme.accentPink),
              title: const Text('Hapus Semua Riwayat Obrolan', style: TextStyle(color: AppTheme.accentPink)),
              subtitle: const Text(
                'Menghapus semua sesi percakapan dari perangkat & cloud database.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              onTap: () {
                _showClearAllDialog(context, chatProvider);
              },
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'TENTANG APLIKASI',
            style: TextStyle(
              color: AppTheme.secondaryNeon,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceDark),
            ),
            child: const Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Versi Aplikasi', style: TextStyle(color: AppTheme.textMuted)),
                    Text('1.0.0+1 Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pengembang', style: TextStyle(color: AppTheme.textMuted)),
                    Text('zzamcode', style: TextStyle(color: AppTheme.secondaryNeon, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Database Engine', style: TextStyle(color: AppTheme.textMuted)),
                    Text('Cloud Encrypted Database', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, ChatProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Hapus Semua Chat?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tindakan ini akan menghapus seluruh riwayat percakapan secara permanen.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink),
            onPressed: () {
              provider.clearAllSessions();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua percakapan telah dihapus.'),
                  backgroundColor: AppTheme.accentPink,
                ),
              );
            },
            child: const Text('Hapus Permanen', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
