import 'dart:async';
import 'dart:io';
import "package:flutter/material.dart";
import "package:camera/camera.dart";
import 'package:flutter/services.dart';
import 'package:multiple_image_camera/image_preview.dart';

class CameraFile extends StatefulWidget {
  final Widget? customButton;
  const CameraFile({super.key, this.customButton});

  @override
  State<CameraFile> createState() => _CameraFileState();
}

class _CameraFileState extends State<CameraFile> with TickerProviderStateMixin {
  double zoom = 0.0;
  double _scaleFactor = 1.0;
  double scale = 1.0;
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  List<XFile> imageFiles = [];
  List<MediaModel> imageList = <MediaModel>[];
  late int _currIndex;
  late Animation<double> animation;
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  bool? flash = false;

  Future<void> toggleFlashlight() async {
    if (_controller!.value.flashMode == FlashMode.off ||
        _controller!.value.flashMode == FlashMode.auto) {
      await _controller!.setFlashMode(FlashMode.torch);
      setState(() {
        flash = true;
      });
    } else {
      await _controller!.setFlashMode(FlashMode.off);
      setState(() {
        flash = false;
      });
    }
  }

  addImages(XFile image) {
    setState(() {
      imageFiles.add(image);
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1500));
      animation = Tween<double>(begin: 400, end: 1).animate(scaleAnimation =
          CurvedAnimation(
              parent: _animationController, curve: Curves.elasticOut))
        ..addListener(() {});
      _animationController.forward();
    });
  }

  removeImage() {
    setState(() {
      imageFiles.removeLast();
    });
  }

  Widget? _animatedButton({Widget? customContent}) {
    return customContent ??
        Container(
          height: 70,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const Center(
            child: Text(
              'Done',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        );
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    // ignore: unnecessary_null_comparison
    if (_cameras != null) {
      _controller = CameraController(_cameras[0], ResolutionPreset.veryHigh,
          enableAudio: false);
      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {}
  }

  @override
  void initState() {
    _initCamera();
    _currIndex = 0;

    super.initState();
  }

  Widget _buildCameraPreview() {
    return GestureDetector(
        onScaleStart: (details) {
          zoom = _scaleFactor;
        },
        onScaleUpdate: (details) {
          _scaleFactor = zoom * details.scale;
          _controller!.setZoomLevel(_scaleFactor);
        },
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              CameraPreview(_controller!),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                shrinkWrap: true,
                itemCount: imageFiles.length,
                itemBuilder: ((context, index) {
                  return Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        // ignore: unnecessary_null_comparison
                        child: imageFiles[index] == null
                            ? const Text("No image captured")
                            : imageFiles.length - 1 == index
                                ? ScaleTransition(
                                    scale: scaleAnimation,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagePreviewView(
                                                          File(imageFiles[index]
                                                              .path),
                                                          "",
                                                        )));
                                      },
                                      child: Stack(
                                        children: [
                                          Image.file(
                                            File(
                                              imageFiles[index].path,
                                            ),
                                            height: 90,
                                            width: 60,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    removeImage();
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ImagePreviewView(
                                                    File(
                                                        imageFiles[index].path),
                                                    "",
                                                  )));
                                    },
                                    child: Image.file(
                                      File(
                                        imageFiles[index].path,
                                      ),
                                      height: 90,
                                      width: 60,
                                    ),
                                  ),
                      )
                    ],
                  );
                }),
                scrollDirection: Axis.horizontal,
              ),
              Positioned(
                right:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 340
                        : null,
                bottom: 0,
                left: 0,
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(
                    Icons.camera_front,
                    color: Colors.white,
                  ),
                  onPressed: _onCameraSwitch,
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 0
                    : null,
                bottom:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 0
                        : MediaQuery.of(context).size.height / 2.5,
                right: 0,
                child: Column(
                  children: [
                    SafeArea(
                      child: IconButton(
                        iconSize: 80,
                        icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                RotationTransition(
                                  turns: child.key == const ValueKey('icon1')
                                      ? Tween<double>(begin: 1, end: 0.75)
                                          .animate(anim)
                                      : Tween<double>(begin: 0.75, end: 1)
                                          .animate(anim),
                                  child: ScaleTransition(
                                      scale: anim, child: child),
                                ),
                            child: _currIndex == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    key: const ValueKey("icon1"),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    key: const ValueKey("icon2"),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  )),
                        onPressed: () {
                          _currIndex = _currIndex == 0 ? 1 : 0;
                          takePicture();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller!.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(
        cameraDescription, ResolutionPreset.ultraHigh,
        enableAudio: false);
    _controller!.addListener(() {
      if (mounted) setState(() {});
      if (_controller!.value.hasError) {}
    });

    try {
      await _controller!.initialize();
      // ignore: empty_catches
    } on CameraException {}
    if (mounted) {
      setState(() {});
    }
  }

  takePicture() async {
    if (_controller!.value.isTakingPicture) {
      return null;
    }
    try {
      final image = await _controller!.takePicture();
      setState(() {
        addImages(image);
        HapticFeedback.lightImpact();
      });
    } on CameraException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      if (!_controller!.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          imageFiles.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    for (int i = 0; i < imageFiles.length; i++) {
                      File file = File(imageFiles[i].path);
                      imageList.add(
                          MediaModel.blob(file, "", file.readAsBytesSync()));
                    }
                    Navigator.pop(context, imageList);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _animatedButton(customContent: widget.customButton),
                  ))
              : const SizedBox(),
          IconButton(
            icon: Icon(
              flash! ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: toggleFlashlight,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: true,
      body: _buildCameraPreview(),
    );
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.setFlashMode(FlashMode.off);
      _controller!.dispose();
    } else {
      // ignore: unnecessary_null_comparison
      if (_animationController != null) {
        _animationController.dispose();
      }
    }
    setState(() {
      flash = false;
    });

    super.dispose();
  }
}

class MediaModel {
  File file;
  String filePath;
  Uint8List blobImage;
  MediaModel.blob(this.file, this.filePath, this.blobImage);
}
