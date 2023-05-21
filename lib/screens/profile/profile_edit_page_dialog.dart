import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pacha/screens/camera_variables_singleton.dart';
import 'package:pacha/screens/profile/list_extensions.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../constants.dart';

class EditPhotoDialog extends StatefulWidget {
  final int? index;
  final bool? isAvatar;
  final List<XFile>? profilePhotos;
  final Function(int index)? removeImage;
  final Function()? addImage;
  const EditPhotoDialog({
    this.index,
    this.isAvatar,
    this.profilePhotos,
    this.removeImage,
    this.addImage,
    Key? key,
  }) : super(key: key);
  @override
  _EditPhotoDialogState createState() => _EditPhotoDialogState();
}

class _EditPhotoDialogState extends State<EditPhotoDialog> {
  Future<File?> cropAvatar(File avatarPhoto) async => await ImageCropper().cropImage(
        sourcePath: avatarPhoto.path,
        aspectRatio: const CropAspectRatio(ratioX: 8, ratioY: 4),
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: androidUiSettingsLocked(),
      );
  AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.grey[800],
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      );
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemprorary = XFile(image.path);
      if (widget.isAvatar! == true) {
        File? croppedFile = await cropAvatar(File(imageTemprorary.path));
        CameraNGalleryVar().avatarPhoto = XFile(croppedFile!.path);
      } else {
        if (CameraNGalleryVar().profileImages.listRange.contains(widget.index)) {
          CameraNGalleryVar().profileImages[widget.index!] = imageTemprorary;
        } else {
          CameraNGalleryVar().orderCounter++;
          CameraNGalleryVar().profileImages.add(imageTemprorary);
        }
      }
      setState(() {});
      widget.isAvatar! == false ? Navigator.of(context).pop() : Navigator.of(context).pop();
    } on PlatformException catch (_) {
      // print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return !CameraNGalleryVar().profileImages.listRange.contains(widget.index)
        ? AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: widget.profilePhotos!.listRange.contains(widget.index)
                ? const Text(
                    "Select a method to pick up an image or remove it",
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    "Select a method to pick up an image",
                    textAlign: TextAlign.center,
                  ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200,
                maxWidth: double.maxFinite,
                minHeight: double.minPositive,
                minWidth: double.maxFinite,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    child: const Text("Camera"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: const Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ),
            ],
          )
        : Dialog(
            insetPadding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Image.file(
                    File(CameraNGalleryVar().profileImages.elementAt(widget.index!).path),
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Constants().appBarBackIcon),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: IconButton(
                              onPressed: () {
                                pickImage(ImageSource.camera);
                              },
                              icon: const Icon(Icons.camera),
                            ),
                          ),
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: IconButton(
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.image),
                            ),
                          ),
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: IconButton(
                              onPressed: () {
                                widget.removeImage!(widget.index!);
                                CameraNGalleryVar().orderCounter--;
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
