import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/screens/chat/message_bubble.dart';

class OutgoingMessageCard extends StatelessWidget {
  final String message;
  final String time;
  const OutgoingMessageCard({
    Key? key,
    required this.message,
    required this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(bottom: Constants().padding * 2, left: Constants().padding * 2, right: Constants().padding),
          child: Stack(
            children: [
              CustomPaint(
                painter: CustomChatBubble(color: Colors.grey.shade600, isOwn: true),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: MarkdownBody(
                    data: message,
                    styleSheet: MarkdownStyleSheet(
                      tableBody: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ));
  }
}
