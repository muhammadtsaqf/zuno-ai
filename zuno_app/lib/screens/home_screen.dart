import 'package:flutter/material';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../models/ai_models.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/app_logo.dart';
import '../widgets/model_selector_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.currentMessages;

    _scrollToBottom();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 28, showGlow: false),
            const SizedBox(width: 8),
            const Text(
              'ZUNO AI',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: AppTheme.secondaryNeon),
            onPressed: () {
              chatProvider.createNewSession();
            },
            tooltip: 'Obrolan Baru',
          ),
        ],
      ),
      body: Column(
        children: [
          // Cyber Banner Info with Model Selector Trigger
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ModelSelectorModal(),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: AppTheme.cardDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.secondaryNeon, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Model: ${AiModels.getModelInfo(chatProvider.selectedModel).displayName}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryNeon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppTheme.secondaryNeon, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '• dev: zzamcode',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 70,
                          color: AppTheme.primaryNeon.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Mulai obrolan cerdas bersama Zuno!',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: messages[index]);
                    },
                  ),
          ),

          // Loading Indicator
          if (chatProvider.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitThreeBounce(
                    color: AppTheme.secondaryNeon,
                    size: 20.0,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Zuno sedang berpikir...',
                    style: TextStyle(
                      color: AppTheme.textMuted.withOpacity(0.8),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ),

          // Input Field Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.bgDark,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.primaryNeon.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _inputController,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        maxLines: 4,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty && !chatProvider.isLoading) {
                            final text = _inputController.text;
                            _inputController.clear();
                            chatProvider.sendMessage(text, userId: authProvider.user?.id);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Tanyakan apa saja pada Zuno...',
                          hintStyle: TextStyle(color: AppTheme.textMuted),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_inputController.text.trim().isNotEmpty && !chatProvider.isLoading) {
                        final text = _inputController.text;
                        _inputController.clear();
                        chatProvider.sendMessage(text, userId: authProvider.user?.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryNeon, AppTheme.secondaryNeon],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryNeon.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
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
