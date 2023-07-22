import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/session_messages_model.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../state/data_state.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';

class MessageItem extends ConsumerStatefulWidget {
  const MessageItem({super.key, this.message});
  final SessionMessagesModel? message;

  @override
  ConsumerState<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends ConsumerState<MessageItem> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
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
    if (widget.message!.mediaFiles != null &&
        widget.message!.mediaFiles!.length == 1) initializeVideo();
  }

  initializeVideo() {
    var file = widget.message!.mediaFiles![0];
    var type = file['type'];
    if (type!.contains('video')) {
      _controller = VideoPlayerController.file(File(file['url']),
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
  Widget build(BuildContext context) {
    var message = widget.message;
    var uid = ref.watch(userProvider).id;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message!.senderId == uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.senderId != uid)
                CircleAvatar(
                    backgroundImage: message.senderImage != null
                        ? NetworkImage(message.senderImage!)
                        : null),
              Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: message.senderId == uid
                          ? primaryColor.withOpacity(0.1)
                          : Colors.white),
                  child: message.type == 'text'
                      ? Text(
                          message.message!,
                          style: normalText(
                            fontSize: 13,
                          ),
                        )
                      : message.type == 'media'
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.mediaFiles!.length == 1)
                                  if (message.mediaFiles![0]['type']
                                      .contains('image'))
                                    Image.network(
                                      message.mediaFiles![0],
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                if (message.mediaFiles!.length == 1)
                                  if (message.mediaFiles![0]['type']
                                      .contains('video'))
                                    Expanded(
                                      child: _chewieController != null
                                          ? Chewie(
                                              controller: _chewieController!,
                                            )
                                          : Container(
                                              alignment: Alignment.center,
                                              child: const SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()))),
                                    ),
                                if (message.mediaFiles!.length > 1)
                                  GridView.builder(
                                    itemCount: message.mediaFiles!.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 2),
                                    itemBuilder: (context, index) {
                                      var file = message.mediaFiles![index];
                                      if (file['type']!.contains('image')) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: secondaryColor,
                                                  width: 2),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      file['url']!),
                                                  fit: BoxFit.cover)),
                                        );
                                      } else {
                                        return FutureBuilder(
                                            future:
                                                genThumbnailFile(file['url']!),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        border: Border.all(
                                                            color:
                                                                secondaryColor,
                                                            width: 2),
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                snapshot.data
                                                                    as File),
                                                            fit: BoxFit.cover)),
                                                    child: const Center(
                                                        child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 24,
                                                    )));
                                              } else {
                                                //loading
                                                return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: secondaryColor,
                                                          width: 2),
                                                    ),
                                                    child: const Center(
                                                        child:
                                                            CircularProgressIndicator()));
                                              }
                                            });
                                      }
                                    },
                                  ),
                                Text(
                                  message.message!,
                                  style: normalText(
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            )
                          : message.type == 'video'
                              ? const Text('Video')
                              : const Text('Audio')),
            ],
          )
        ],
      ),
    );
  }

  Future genThumbnailFile(String url) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 90,
      quality: 90,
    );
    File file = File(fileName!);
    return file;
  }
}
