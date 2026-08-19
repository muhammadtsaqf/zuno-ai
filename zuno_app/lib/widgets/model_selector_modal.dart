import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_models.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class ModelSelectorModal extends StatelessWidget {
  const ModelSelectorModal({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 20,
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
                  Icon(Icons.psychology_rounded, color: AppTheme.secondaryNeon),
                  SizedBox(width: 10),
                  Text(
                    'Pilih Engine AI Zuno',
                    style: TextStyle(
                      fontSize: 18,
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
          const Divider(color: AppTheme.surfaceDark, height: 20),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: AiModels.availableModels.map((model) {
                  final isSelected = model.id == chatProvider.selectedModel;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryNeon.withOpacity(0.15)
                          : AppTheme.bgDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.secondaryNeon
                            : AppTheme.surfaceDark,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? AppTheme.secondaryNeon
                            : AppTheme.surfaceDark,
                        child: Icon(
                          isSelected ? Icons.check : Icons.auto_awesome,
                          color: isSelected ? Colors.black : AppTheme.textMuted,
                          size: 20,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            model.displayName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              model.provider,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.secondaryNeon,
                              ),
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          model.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                      onTap: () {
                        chatProvider.setSelectedModel(model.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
