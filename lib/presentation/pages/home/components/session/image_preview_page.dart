import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:online_counsellor/core/components/widgets/smart_dialog.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../core/components/widgets/custom_input.dart';
import '../../../../../models/session_messages_model.dart';
import '../../../../../services/firebase_fireStore.dart';
import '../../../../../services/firebase_storage.dart';
import '../../../../../state/data_state.dart';

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
  ChewieController? _chewieController;
  final TextEditingController _captionController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  initializeVideo() {
    //dispose previous video
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.dispose();
    }
    _controller = null;
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    _chewieController = null;
    var file = widget.imageUrls![index];
    var type = lookupMimeType(file.path);
    if (type!.contains('video')) {
      _controller = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true, allowBackgroundPlayback: true))
        ..initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: 0.9,
        autoPlay: true,
        autoInitialize: true,
        looping: false,
        showOptions: false,
        allowFullScreen: false,
        allowMuting: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            //close button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black))
              ],
            ),
            const SizedBox(height: 10),
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
                  return _chewieController != null
                      ? Chewie(
                          controller: _chewieController!,
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: const SizedBox(
                              height: 80,
                              width: 80,
                              child:
                                  Center(child: CircularProgressIndicator())));
                }
              }),
            ),
            //list of images
            if (widget.imageUrls!.length > 1)
              SizedBox(
                width: size.width,
                height: 80,
                child: ListView.builder(
                    itemCount: widget.imageUrls!.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var initFile = widget.imageUrls![index];
                      File file = initFile;
                      var type = lookupMimeType(initFile.path);
                      if (type!.contains('video')) {
                        return FutureBuilder(
                            future: genThumbnailFile(initFile),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: index == this.index
                                              ? Border.all(
                                                  color: secondaryColor,
                                                  width: 4)
                                              : null,
                                          image: DecorationImage(
                                              image: FileImage(
                                                  snapshot.data as File),
                                              fit: BoxFit.cover)),
                                      child: const Center(
                                          child: Icon(Icons.play_arrow,
                                              color: Colors.white))),
                                );
                              }
                              return Container(
                                  height: 80,
                                  width: 80,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            });
                      }
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
                              border: index == this.index
                                  ? Border.all(color: secondaryColor, width: 4)
                                  : null,
                              image: DecorationImage(
                                  image: FileImage(file), fit: BoxFit.cover)),
                        ),
                      );
                    }),
              ),
            const SizedBox(height: 10),
            //add caption and send button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      hintText: 'Type caption',
                      controller: _captionController,
                      onChanged: (value) {},
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                sendMessages();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: primaryColor,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )

            //send button
          ]),
        ),
      ),
    );
  }

  Future genThumbnailFile(File video) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: video.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 90,
      quality: 90,
    );
    File file = File(fileName!);
    return file;
  }

  void sendMessages() async {
    //show loading
    CustomDialog.showLoading(
      message: 'Sending media files...',
    );
    //send media files to firebase storage and get the urls
    List<Map<String, dynamic>> uploads = [];
    //add all files and their types
    for (var i = 0; i < widget.imageUrls!.length; i++) {
      var file = widget.imageUrls![i];
      var type = lookupMimeType(file.path);
      uploads.add({'type': type!, 'file': file});
    }
    List<Map<String, dynamic>> mediaUrls =
        await CloudStorageServices.sedFiles(uploads, widget.session!.id!);
    var session = widget.session!;

    //send message to firebase firestore
    var uid = ref.watch(userProvider).id;
    var receiverId =
        uid == session.userId ? session.counsellorId! : session.userId;
    var receiverName =
        uid == session.userId ? session.counsellorName! : session.userName;
    var receiverImage =
        uid == session.userId ? session.counsellorImage! : session.userImage!;
    SessionMessagesModel messagesModel = SessionMessagesModel();
    messagesModel.message = _captionController.text;
    messagesModel.type = 'media';
    messagesModel.senderId = uid;
    messagesModel.senderName = ref.watch(userProvider).name;
    messagesModel.senderImage = ref.watch(userProvider).profile;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.mediaFiles = mediaUrls;
    messagesModel.createdAt = DateTime.now().millisecondsSinceEpoch;
    messagesModel.id = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('sessions')
            .doc(session.id)
            .collection('messages'));
    messagesModel.sessionId = session.id;
    var result = await FireStoreServices.addSessionMessages(messagesModel);
    if (result) {
      setState(() {
        _captionController.clear();
      });
      //close loading
      CustomDialog.dismiss();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
