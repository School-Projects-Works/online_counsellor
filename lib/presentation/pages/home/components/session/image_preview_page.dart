import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:video_player/video_player.dart';

class ImagePreviewPage extends ConsumerStatefulWidget {
  const ImagePreviewPage(this.imageUrls, this.session, {super.key});
  final List<File>? imageUrls;
  final SessionModel? session;

  @override
  ConsumerState<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends ConsumerState<ImagePreviewPage> {
  int index = 0;
  VideoPlayerController? _controller;

  @override
  void dispose() {
    super.dispose();
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  initializeVideo() {
    var file = widget.imageUrls![index];
    var type = lookupMimeType(file.path);
    if (type!.contains('video')) {
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.3),
      body: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            //close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                var type = lookupMimeType(widget.imageUrls![index].path);
                if (type!.contains('image')) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(widget.imageUrls![index]),
                            fit: BoxFit.cover)),
                  );
                } else {
                  return _controller != null && _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : const LinearProgressIndicator();
                }
              }),
            ),
            //list of images
            SizedBox(
              width: size.width,
              height: 80,
              child: ListView.builder(
                  itemCount: widget.imageUrls!.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          this.index = index;
                          initializeVideo();
                        });
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: FileImage(widget.imageUrls![index]),
                                fit: BoxFit.cover)),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 10),

            //send button
          ])),
    );
  }
}
