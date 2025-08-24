<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Flutter package for both android and iOS which provides Take Multiple Images from Camera.


## Features

- Display live camera preview in a widget.
- You can Switch Camera if you want to take photo from front Camera.
- Take Multiple Photos at once and them in the list.
- This package contains pre-canned animations for commonly-desired effects.
- This package also have Camera shutter vibration.
- Ability for Show images that are clicked and added to the list.
- You can zoom in or zoom out with pinch to zoom.

## Screenshots

![Alt text](/assets/example.png)
![Alt text](/assets/example1.png)
![Alt text](/assets/example2.png)

## Installation

First, add multiple_image_camera as a dependency in your pubspec.yaml file.

iOS

- The multiple_image_camera plugin compiles for any version of iOS, but its functionality requires iOS 10 or higher. If compiling for iOS 9, make sure to programmatically check the version of iOS running on the device before using any multiple_image_camera plugin features. The device_info_plus plugin, for example, can be used to check the iOS version.
Add two rows to the ios/Runner/Info.plist:

- one with the key Privacy - Camera Usage Description and a usage description.
and one with the key Privacy - Microphone Usage Description and a usage description.
If editing Info.plist as text, add:

- NSCameraUsageDescription your usage description here NSMicrophoneUsageDescription your usage description here

Android

Change the minimum Android sdk version to 21 (or higher) in your android/app/build.gradle file.

minSdkVersion 21

## Usage

TODO: Here is a small example flutter app displaying a full screen camera preview with taking multiple images.

```dart
List<MediaModel> images = [] ;
 ElevatedButton(
            child: const Text("Capture"),
            onPressed: () async {
            MultipleImageCamera.capture(context: context).then((value) {
              setState(() {
                images = value ;
              });
            });
          
            },
          ),
          
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.file(File(images[index].file.path));
                }),
          )
```

