import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/screens/chat/message_bubble.dart';

class IncomingMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final bool isItChannel;
  const IncomingMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.isItChannel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Constants().padding * 2, right: Constants().padding * 2, left: isItChannel ? Constants().padding / 2 : Constants().padding * 1.2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: isItChannel,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/profile/details');
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'http://thecaretta.com/model/photo-1.jpg',
                  ),
                ),
              ),
            ),
            Padding(
              padding: isItChannel
                  ? const EdgeInsets.only(
                      left: 8.0,
                    )
                  : const EdgeInsets.only(left: 0.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: CustomChatBubble(color: Colors.grey.shade800, isOwn: false),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 30,
                          top: 5,
                          bottom: 25,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
