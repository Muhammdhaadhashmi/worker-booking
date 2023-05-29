import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/spaces.dart';
import '../../../../Utils/text_view.dart';
import '../../Models/chat_model.dart';

class ChatListItem extends StatefulWidget {
  final int index;
  final ChatModel chatModel;

  const ChatListItem({super.key, required this.index, required this.chatModel});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.chatModel.isme);
    return Align(
      alignment: widget.chatModel.isme ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: widget.chatModel.isme
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))
              : BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: widget.chatModel.isme
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            TextView(
              text: '${widget.chatModel.message}',
              fontSize: 16,
            ),
            AddVerticalSpace(5),
            TextView(
              text: '${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(widget.chatModel.time))}',
              fontSize: 8,
              color: AppColors.mainColor,
            ),
//   isSeen!
//       ? Image.asset(
//           kDoubleTick,
//           height: 10,
//         )
//       : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
