import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/constants/app_string_constant.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/text_theme.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/data/models/chatbot_model.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isChatActive.value) {
            return _buildChatSession(context);
          } else {
            return _buildChatHistory(context);
          }
        }),
      ),
    );
  }

  // ==================== CHAT HISTORY VIEW ====================

  Widget _buildChatHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isHistory: true),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.l10n.conversationHistory,
                  style: const MainTextTheme().titleLarge?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.loadSessions,
                icon: const Icon(
                  Icons.refresh,
                  color: ColorConstant.primary,
                  size: 22,
                ),
                tooltip: context.l10n.refreshHistory,
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingSessions.value) {
              return const Center(
                child: CircularProgressIndicator(color: ColorConstant.primary),
              );
            }

            if (controller.sessionsErrorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: ColorConstant.redColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.sessionsErrorMessage.value,
                        textAlign: TextAlign.center,
                        style: const MainTextTheme().bodyMedium?.copyWith(
                          color: ColorConstant.textDarkGreyColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.loadSessions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primary,
                        ),
                        child: Text(
                          context.l10n.tryAgain,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (controller.sessions.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: ColorConstant.primary,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.noConversationsYet,
                        style: const MainTextTheme().titleLarge?.copyWith(
                          color: ColorConstant.textDarkGreyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.emptyConversationDesc,
                        textAlign: TextAlign.center,
                        style: const MainTextTheme().bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: controller.startNewChat,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(
                          context.l10n.startNewConversation,
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: controller.sessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.sessions[index];
                final title = item.firstMessage.isNotEmpty
                    ? item.firstMessage
                    : 'Percakapan #${item.id}';

                return Semantics(
                  button: true,
                  label:
                      'Riwayat percakapan: $title. Ketuk untuk membuka percakapan.',
                  child: GestureDetector(
                    onTap: () => controller.openSession(item.id),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: ColorConstant.shadowColor,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: ColorConstant.background,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: ColorConstant.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const MainTextTheme().titleMedium
                                      ?.copyWith(
                                        color: ColorConstant.textDarkGreyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sesi ID: ${item.id}',
                                  style: const MainTextTheme().bodySmall
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: ColorConstant.textGreyColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // ==================== CHAT SESSION VIEW ====================

  Widget _buildChatSession(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, isHistory: false),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingMessages.value) {
              return const Center(
                child: CircularProgressIndicator(color: ColorConstant.primary),
              );
            }

            if (controller.messagesErrorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: ColorConstant.redColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.messagesErrorMessage.value,
                        textAlign: TextAlign.center,
                        style: const MainTextTheme().bodyMedium?.copyWith(
                          color: ColorConstant.textDarkGreyColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.currentSessionId.value != null) {
                            controller.loadMessages(
                              controller.currentSessionId.value!,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primary,
                        ),
                        child: Text(
                          context.l10n.tryAgain,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(20),
              itemCount:
                  controller.messages.length +
                  (controller.isSendingMessage.value ? 1 : 0),
              itemBuilder: (context, index) {
                // If this is the extra item at the bottom while sending:
                if (index == controller.messages.length) {
                  return _buildThinkingBubble();
                }

                final msg = controller.messages[index];
                return _buildMessageBubble(context, msg);
              },
            );
          }),
        ),
        _buildSuggestedQuestionsBar(),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageResponse msg) {
    final isAi = msg.role.toLowerCase() == 'assistant';

    return Semantics(
      container: true,
      label:
          'Pesan dari ${isAi ? "${AppStrings.nameApp} AI" : "Anda"}: ${msg.content}',
      child: Align(
        alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.only(
            bottom: 16,
            right: isAi ? 32 : 0,
            left: isAi ? 0 : 32,
          ),
          decoration: BoxDecoration(
            color: isAi ? ColorConstant.white : ColorConstant.primary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomRight: Radius.circular(isAi ? 16 : 4),
              bottomLeft: Radius.circular(isAi ? 4 : 16),
            ),
            boxShadow: const [
              BoxShadow(
                color: ColorConstant.shadowColor,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg.content,
                style: const MainTextTheme().bodyLarge?.copyWith(
                  color: isAi
                      ? ColorConstant.textDarkGreyColor
                      : ColorConstant.white,
                  height: 1.5,
                ),
              ),
              if (isAi &&
                  msg.citations != null &&
                  msg.citations!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildCitationsSection(msg.citations!, context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCitationsSection(List<SourceCitation> citations, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorConstant.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorConstant.borderBlueGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book,
                size: 16,
                color: ColorConstant.primary,
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.referenceSources,
                style: const MainTextTheme().bodySmall?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...citations.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '• ${c.label} (${c.reference})',
                style: const MainTextTheme().bodySmall?.copyWith(
                  color: ColorConstant.textDarkGreyColor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16, right: 48),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: ColorConstant.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorConstant.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'NovaSight AI sedang berpikir...',
              style: const MainTextTheme().bodyMedium?.copyWith(
                color: ColorConstant.textGreyColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestionsBar() {
    return Obx(() {
      final questions = controller.suggestedQuestions;
      if (questions.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: ColorConstant.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: ColorConstant.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pertanyaan Lanjutan yang Disarankan:',
                    style: const MainTextTheme().bodySmall?.copyWith(
                      color: ColorConstant.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: questions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return ActionChip(
                    label: Text(
                      q,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorConstant.primary,
                      ),
                    ),
                    backgroundColor: ColorConstant.white,
                    side: const BorderSide(color: ColorConstant.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () => controller.askSuggestedQuestion(q),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==================== COMMON HEADER & INPUT ====================

  Widget _buildHeader(BuildContext context, {required bool isHistory}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(color: ColorConstant.primary),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left action slot (40px)
          SizedBox(
            width: 40,
            height: 40,
            child: !isHistory
                ? Center(
                    child: Semantics(
                      button: true,
                      label: 'Kembali ke riwayat percakapan',
                      child: IconButton(
                        onPressed: controller.backToHistory,
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          color: ColorConstant.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Kembali ke riwayat percakapan',
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),

          // Center title & subtitle
          Expanded(
            child: Semantics(
              header: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Clarifier AI',
                    textAlign: TextAlign.center,
                    style: const MainTextTheme().titleLarge?.copyWith(
                          color: ColorConstant.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.clarifierSubtitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const MainTextTheme().bodyMedium?.copyWith(
                          color: const Color(0xE6FFFFFF),
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Right action slot (40px)
          SizedBox(
            width: 40,
            height: 40,
            child: isHistory
                ? Center(
                    child: Semantics(
                      button: true,
                      label: 'Mulai percakapan baru',
                      child: GestureDetector(
                        onTap: controller.startNewChat,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: ColorConstant.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        border: Border(top: BorderSide(color: ColorConstant.borderBlueGrey)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'Kolom input pesan',
                textField: true,
                child: TextField(
                  controller: controller.textController,
                  onSubmitted: (_) => controller.sendMessage(),
                  style: const MainTextTheme().bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Tanya materi atau soal...',
                    hintStyle: const MainTextTheme().bodyLarge?.copyWith(
                      color: ColorConstant.textGreyColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: ColorConstant.borderBlueGrey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: ColorConstant.borderBlueGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: ColorConstant.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Semantics(
              button: true,
              label: 'Kirim pesan',
              child: GestureDetector(
                onTap: controller.sendMessage,
                child: Obx(() {
                  final canSend =
                      controller.hasInput.value &&
                      !controller.isSendingMessage.value;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: canSend
                          ? ColorConstant.primary
                          : const Color(0xFFB4C0DA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: ColorConstant.white,
                      size: 24,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
