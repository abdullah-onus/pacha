import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pacha/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:pacha/screens/chat/gallery_view.dart';
import 'package:pacha/screens/chat/incoming_photo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pacha/screens/chat/incoming_video.dart';
import 'package:pacha/screens/chat/outgoing_message_card.dart';
import 'package:pacha/screens/chat/incoming_message_card.dart';
import 'package:pacha/screens/chat/outgoing_photo.dart';
import 'package:pacha/screens/chat/outgoing_video.dart';

class ScreenChatChannel extends StatefulWidget {
  const ScreenChatChannel({Key? key}) : super(key: key);
  @override
  _ScreenChatChannelState createState() => _ScreenChatChannelState();
}

List<ChatMessage> channelMessages = [];

class _ScreenChatChannelState extends State<ScreenChatChannel> {
  int popTime = 0;
  late XFile file;
  late List<XFile> multipleImage;
  ImagePicker picker = ImagePicker();
  Color buttonColor = Colors.white;
  final ScrollController _scrollController = ScrollController();
  final textEditingControllerMessage = TextEditingController();
  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return SafeArea(
        child: Stack(children: [
      Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Wait API CONNECTION'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.clear_outlined)),
              ],
            ),
          ),
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: channelMessages.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        if (index % 2 == 0) {
                          if (channelMessages[index].type == 'message') {
                            return IncomingMessageCard(
                              message: channelMessages[index].messageContent,
                              time: channelMessages[index].time,
                              isItChannel: true,
                            );
                          } else if (channelMessages[index].type == 'photo') {
                            return IncomingPhoto(
                              path: channelMessages[index].path,
                              isItChannel: true,
                            );
                          } else {
                            return IncomingVideo(
                              path: channelMessages[index].path,
                              isItChannel: true,
                            );
                          }
                        } else {
                          if (channelMessages[index].type == 'photo') {
                            return OutgoingPhoto(
                              path: channelMessages[index].path,
                            );
                          } else if (channelMessages[index].type == 'message') {
                            return OutgoingMessageCard(
                              message: channelMessages[index].messageContent,
                              time: channelMessages[index].time,
                            );
                          } else {
                            return OutgoingVideo(
                              path: channelMessages[index].path,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Card(
                                margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: TextField(
                                  maxLines: 5,
                                  minLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  controller: textEditingControllerMessage,
                                  onChanged: (value) {
                                    setState(() {
                                      if (textEditingControllerMessage.text.isNotEmpty && !isAllSpaces(textEditingControllerMessage.text)) {
                                        buttonColor = Colors.amber;
                                      }
                                    });
                                  },
                                  onEditingComplete: () => buttonColor = Colors.white,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).screenChatTextFieldHintText,
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.photo_library),
                                          color: Colors.grey,
                                          onPressed: () async {
                                            popTime = 1;
                                            multipleImage = (await picker.pickMultiImage())!;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) => GalleryViewPage(
                                                          path: multipleImage.map((path) => path.path).toList(),
                                                          onImagesSend: onImagesSend,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                            icon: const Icon(Icons.video_camera_back),
                                            color: Colors.grey,
                                            onPressed: () async {
                                              final image = await ImagePicker().pickVideo(source: ImageSource.camera);
                                              if (image == null) return;
                                              setState(() {
                                                onVideoSend(image.path);
                                              });
                                            }),
                                        IconButton(
                                            icon: const Icon(Icons.camera_alt),
                                            color: Colors.grey,
                                            onPressed: () async {
                                              // popTime = 2;
                                              final image = await ImagePicker().pickImage(source: ImageSource.camera);
                                              if (image == null) return;
                                              setState(() {
                                                onImageSend(image.path);
                                              });
                                            }),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: IconButton(
                                    iconSize: 35,
                                    color: buttonColor,
                                    onPressed: () {
                                      setState(() {
                                        if (textEditingControllerMessage.text.isNotEmpty && !isAllSpaces(textEditingControllerMessage.text)) {
                                          sendMessage(textEditingControllerMessage.text, textEditingControllerMessage, DateTime.now().toString());
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.send)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ])))
    ]));
  }

  bool isAllSpaces(String input) => input.replaceAll(RegExp(r'\s'), '') == '';
  void sendMessage(String message, TextEditingController controller, String dateString) {
    String time = DateFormat.Hm().format(DateTime.parse(dateString));
    channelMessages.add(ChatMessage(messageContent: message, time: time, type: 'message', path: ''));
    controller.clear();
    buttonColor = Colors.white;
  }

  void onImageSend(String path) {
    channelMessages.add(ChatMessage(
      path: path,
      time: 'time',
      type: 'photo',
      messageContent: '',
    ));
    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
  }

  void onImagesSend(List<String> path) {
    for (int i = 0; i < path.length; i++) {
      channelMessages.add(ChatMessage(
        path: path[i],
        time: 'time',
        type: 'photo',
        messageContent: '',
      ));
    }
    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
  }

  void onVideoSend(String path) {
    channelMessages.add(ChatMessage(
      path: path,
      time: 'time',
      type: 'video',
      messageContent: '',
    ));
    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
  }
}
