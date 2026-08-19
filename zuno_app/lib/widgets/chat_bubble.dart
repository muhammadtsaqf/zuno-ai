import 'package:flutter/material';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final timeStr = DateFormat('HH:mm').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryNeon, AppTheme.secondaryNeon],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryNeon.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.userBubbleColor : AppTheme.aiBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                    border: Border.all(
                      color: isUser
                          ? AppTheme.primaryNeon.withOpacity(0.5)
                          : AppTheme.surfaceDark,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? AppTheme.primaryNeon.withOpacity(0.2)
                            : Colors.black25,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: isUser
                      ? Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(color: AppTheme.textLight, fontSize: 15, height: 1.5),
                            code: TextStyle(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              color: AppTheme.secondaryNeon,
                              fontFamily: 'monospace',
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: const Color(0xFF141322),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.primaryNeon.withOpacity(0.3)),
                            ),
                            h1: const TextStyle(color: AppTheme.secondaryNeon, fontWeight: FontWeight.bold),
                            h2: const TextStyle(color: AppTheme.secondaryNeon, fontWeight: FontWeight.bold),
                            h3: const TextStyle(color: AppTheme.secondaryNeon, fontWeight: FontWeight.bold),
                            blockquoteDecoration: BoxDecoration(
                              color: AppTheme.primaryNeon.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      color: AppTheme.textMuted.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceDark,
                border: Border.all(color: AppTheme.primaryNeon.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.secondaryNeon,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
