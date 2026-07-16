import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/chat_model.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/text_theme.dart';
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

  Widget _buildChatHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isHistory: true),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Riwayat Percakapan',
            style: const MainTextTheme().titleLarge?.copyWith(
              color: ColorConstant.textDarkGreyColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.chatHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ChatHistoryItem item = controller.chatHistory[index];
                return Semantics(
                  button: true,
                  label:
                      'Riwayat percakapan: ${item.title}. Ketuk untuk membuka percakapan.',
                  child: ExcludeSemantics(
                    child: GestureDetector(
                      onTap: () => controller.openChat(index),
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
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: ColorConstant.background,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: ColorConstant.textGreyColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const MainTextTheme().titleLarge
                                        ?.copyWith(
                                          color: ColorConstant.informationColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: const MainTextTheme().bodyLarge
                                        ?.copyWith(
                                          color: ColorConstant.textGreyColor,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatSession(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, isHistory: false),
        Expanded(
          child: ListView(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Hari ini',
                    style: const MainTextTheme().bodyLarge?.copyWith(
                      color: ColorConstant.textGreyColor,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: controller.messages.map<Widget>((ChatMessage msg) {
                    final isAi = msg.sender == 'ai';
                    return Semantics(
                      label:
                          'Pesan dari ${isAi ? 'NovaSight AI' : 'Anda'}: ${msg.message} pada ${msg.time}',
                      child: ExcludeSemantics(
                        child: Align(
                          alignment: isAi
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: isAi
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.only(
                                  bottom: 8,
                                  right: isAi ? 32 : 0,
                                  left: isAi ? 0 : 32,
                                ),
                                decoration: BoxDecoration(
                                  color: isAi
                                      ? ColorConstant.white
                                      : ColorConstant.primary,
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
                                child: Text(
                                  msg.message,
                                  style: const MainTextTheme().bodyLarge
                                      ?.copyWith(
                                        color: isAi
                                            ? ColorConstant
                                                  .lightInformationColor
                                            : ColorConstant.white,
                                        height: 1.5,
                                      ),
                                ),
                              ),
                              Text(
                                msg.time,
                                style: const MainTextTheme().bodyMedium
                                    ?.copyWith(
                                      color: ColorConstant.textGreyColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isHistory}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(color: ColorConstant.primary),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'NovaSight AI',
                  style: const MainTextTheme().titleLarge?.copyWith(
                    color: ColorConstant.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teman belajar matematikamu',
                  style: const MainTextTheme().bodyLarge?.copyWith(
                    color: const Color(0xE6FFFFFF), // white with 0.9 opacity
                  ),
                ),
              ],
            ),
          ),
          if (!isHistory)
            Positioned(
              left: 0,
              child: Semantics(
                button: true,
                label: 'Kembali ke riwayat percakapan',
                child: IconButton(
                  onPressed: controller.backToHistory,
                  icon: const Icon(
                    Icons.arrow_back_ios_sharp,
                    color: ColorConstant.white,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          if (isHistory)
            Positioned(
              right: 0,
              child: Semantics(
                button: true,
                label: 'Mulai percakapan baru',
                child: GestureDetector(
                  onTap: controller.startNewChat,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF), // white with 0.2 opacity
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: ColorConstant.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    hintText: 'Tanya sesuatu...',
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
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: controller.hasInput.value
                          ? ColorConstant.primary
                          : const Color(0xFFB4C0DA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: ColorConstant.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
