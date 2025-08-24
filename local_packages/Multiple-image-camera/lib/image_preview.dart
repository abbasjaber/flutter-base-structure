import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreviewView extends StatefulWidget {
  final File file;
  final String imageTitle;

  const ImagePreviewView(this.file, this.imageTitle, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePreviewViewState createState() => _ImagePreviewViewState();
}

class _ImagePreviewViewState extends State<ImagePreviewView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 1,
        title: Text(
          widget.imageTitle,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
      ),
      body: InteractiveViewer(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
              reverse: true,
              child: SizedBox(
                width: double.infinity,
                child: Hero(
                  tag: widget.file.path,
                  child: Image.file(
                    widget.file,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              )),
        ),
      )),
    );
  }

  Future decodeImage() async {
    // ignore: prefer_typing_uninitialized_variables
    var decodedImage;

    decodedImage = await decodeImageFromList(widget.file.readAsBytesSync());
   
    return decodedImage.width.toDouble();
  }
}
