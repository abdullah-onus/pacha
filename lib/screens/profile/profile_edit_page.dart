import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'package:pacha/globals.dart';
import 'package:pacha/models/size_config.dart';
import 'package:pacha/pacha_api.dart';
import 'package:pacha/screens/camera_variables_singleton.dart';
import 'package:pacha/screens/profile/list_extensions.dart';
import 'package:pacha/screens/profile/profile_edit_page_dialog.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  var userFullName = TextEditingController();
  var userBio = TextEditingController();
  var userInsta = TextEditingController();
  var userTwitter = TextEditingController();
  var userFacebook = TextEditingController();
  var userWebsite = TextEditingController();
  late double initialPhotoWidth;
  late double photoHeight;
  late double photoWidth;
  late double photoWidthDifference;
  bool isNotSizedOnce = true;
  bool isAvatar = false;
  void initialSizeAdjustment() {
    if (isNotSizedOnce) {
      SizeConfig().init(context);
      initialPhotoWidth = MediaQuery.of(context).size.width / 100 * 25;
      photoHeight = MediaQuery.of(context).size.height / 100 * 25;
      photoWidth = MediaQuery.of(context).size.width / 100 * 25;
      photoWidthDifference = photoWidth - initialPhotoWidth;
      isNotSizedOnce == false;
    }
  }

  @override
  void initState() {
    CameraNGalleryVar().orderCounter = CameraNGalleryVar().profileImages.length;
    userFullName.text = Globals.user!.fullname ?? '';
    userBio.text = Globals.user!.bio ?? '';
    userInsta.text = Globals.user!.instagram ?? '';
    userTwitter.text = Globals.user!.twitter ?? '';
    userFacebook.text = Globals.user!.facebook ?? '';
    userWebsite.text = Globals.user!.website ?? '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    initialSizeAdjustment();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUser(BuildContext context) async {
    PaChaAPI()
        .userSet(
            fullname: userFullName.text,
            bio: userBio.text,
            facebook: userFacebook.text,
            twitter: userTwitter.text,
            instagram: userInsta.text,
            website: userWebsite.text)
        .then((response) {})
        .whenComplete(() {})
        .onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Constants().appBarBackIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text("Edit Profile"),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Upload Photos'),
              )
            ],
          ),
          body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: Constants().padding, bottom: Constants().padding, right: Constants().padding),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Constants().padding),
                        child: Column(
                          children: [
                            // avatar ---------------------------------
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: CameraNGalleryVar().avatarPhoto == null
                                  ? Image.network(Globals.user!.avatar ?? '')
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: Image.file(
                                        File(CameraNGalleryVar().avatarPhoto!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditPhotoDialog(
                                      isAvatar: true,
                                      profilePhotos: CameraNGalleryVar().profileImages,
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                child: const Text("Upload Avatar"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // photos -------------------------
                      SizedBox(
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              children: [
                                Stack(
                                  children: [
                                    template(1, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(0),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    template(2, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(1),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    template(3, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(2),
                                  ],
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Stack(
                                  children: [
                                    template(4, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(3),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    template(5, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(4),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    template(6, CameraNGalleryVar().profileImages.length + 1),
                                    photoIndexCheck(5),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Constants().padding),
                      inputTextFields(
                        userFullName,
                        userFullName.text,
                        AppLocalizations.of(context).screenSignupTextFieldFullnameText,
                        64,
                        1,
                      ),
                      inputTextFields(
                        userBio,
                        userBio.text,
                        "Bio",
                        500,
                        5,
                      ),
                      inputTextFields(
                        userInsta,
                        userInsta.text,
                        "Instagram",
                        30,
                        1,
                      ),
                      inputTextFields(
                        userTwitter,
                        userTwitter.text,
                        "Twitter",
                        15,
                        1,
                      ),
                      inputTextFields(
                        userFacebook,
                        userFacebook.text,
                        "Facebook",
                        50,
                        1,
                      ),
                      inputTextFields(
                        userWebsite,
                        userWebsite.text,
                        "Website",
                        512,
                        1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget inputTextFields(TextEditingController controller, String inputText, String label, int maxLength, int? maxLines) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constants().padding),
      child: TextFormField(
          maxLength: maxLength,
          keyboardType: TextInputType.streetAddress,
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
          onFieldSubmitted: (value) {
            setState(() {
              controller.text = value.trim();
            });
            setUser(context);
          }),
    );
  }

  BoxConstraints boxConstraintsBuilder(double height, double width) {
    return BoxConstraints(
      maxHeight: height,
      minHeight: height,
      maxWidth: width,
      minWidth: width,
    );
  }

  Widget photoIndexCheck(int index) {
    return CameraNGalleryVar().profileImages.listRange.contains(index)
        ? photos(CameraNGalleryVar().profileImages.length - CameraNGalleryVar().orderCounter + index)
        : Visibility(
            visible: false,
            child: Container(),
          );
  }

  Widget photos(int index) {
    return Stack(
      key: UniqueKey(),
      children: [
        Draggable(
          data: index,
          child: DragTarget(
            builder: (context, candidateData, rejectedData) => draggablePhoto(index),
            onWillAccept: (data) {
              if (data != index) {
                return true;
              } else {
                return false;
              }
            },
            onAccept: (data) {
              var oldIndex = int.parse(data.toString());
              var newIndex = index;
              setState(() {
                final element = CameraNGalleryVar().profileImages.removeAt(oldIndex);
                CameraNGalleryVar().profileImages.insert(newIndex, element);
              });
            },
          ),
          feedback: draggablePhoto(index),
          childWhenDragging: template(index + 1, CameraNGalleryVar().profileImages.length + 1),
        ),
      ],
    );
  }

  Widget template(int count, int length) {
    return GestureDetector(
      onTap: () {
        if (count == length) {
          showDialog(
            context: context,
            builder: (context) => EditPhotoDialog(
              index: count,
              isAvatar: false,
              profilePhotos: CameraNGalleryVar().profileImages,
            ),
          ).then((_) {
            setState(() {});
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          height: photoHeight,
          width: photoWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Visibility(
            visible: count == length,
            child: Icon(
              Icons.add,
              color: Colors.amber[700],
              size: SizeConfig.safeBlockVertical! * 5,
            ),
          ),
        ),
      ),
    );
  }

  Widget draggablePhoto(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ConstrainedBox(
        constraints: boxConstraintsBuilder(
          photoHeight,
          photoWidth,
        ),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => EditPhotoDialog(
                index: index,
                isAvatar: false,
                profilePhotos: CameraNGalleryVar().profileImages,
                removeImage: (index) {
                  setState(() {
                    CameraNGalleryVar().profileImages.removeAt(index);
                  });
                },
              ),
            ).then((_) {
              setState(() {});
            });
          },
          child: ConstrainedBox(
            constraints: boxConstraintsBuilder(
              photoHeight,
              photoWidth,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Image.file(
                File(CameraNGalleryVar().profileImages.elementAt(index).path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
