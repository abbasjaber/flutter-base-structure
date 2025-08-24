library multiple_image_camera;

import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';

class MultipleImageCamera {
  static Future<List<MediaModel>> capture(
      {required BuildContext context, Widget? customDoneButton}) async {
    List<MediaModel> images = [];
    try {
      images = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CameraFile(
                    customButton: customDoneButton,
                  )));
      // ignore: empty_catches
    } catch (e) {}
    return images;
  }
}
