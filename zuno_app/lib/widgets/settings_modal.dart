import 'package:flutter/material';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({super.key});

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ChatProvider>(context, listen: false);
    _controller = TextEditingController(text: provider.vercelBackendUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_rounded, color: AppTheme.secondaryNeon),
                  SizedBox(width: 10),
                  Text(
                    'Pengaturan Zuno AI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: AppTheme.surfaceDark, height: 30),
          const Text(
            'Server Backend URL Custom (Opsional):',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kosongkan untuk menggunakan Default Cloud Engine. Jika diisi, request AI akan dialirkan melalui Server Custom Anda.',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppConfig.defaultVercelBackendUrl,
              hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.5)),
              filled: true,
              fillColor: AppTheme.bgDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppTheme.primaryNeon.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.secondaryNeon, width: 2),
              ),
              prefixIcon: const Icon(Icons.link_rounded, color: AppTheme.secondaryNeon),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryNeon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              onPressed: () {
                final provider = Provider.of<ChatProvider>(context, listen: false);
                provider.setVercelUrl(_controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan Server Backend diperbarui!'),
                    backgroundColor: AppTheme.primaryNeon,
                  ),
                );
              },
              child: const Text(
                'Simpan Pengaturan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
