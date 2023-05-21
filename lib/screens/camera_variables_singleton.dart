import 'package:image_picker/image_picker.dart';

class CameraNGalleryVar {
  static final CameraNGalleryVar _instance = CameraNGalleryVar._internal();
  factory CameraNGalleryVar() => _instance;
  CameraNGalleryVar._internal();
  List<XFile> profileImages = [];
  XFile? avatarPhoto;
  int orderCounter = 0;
}
