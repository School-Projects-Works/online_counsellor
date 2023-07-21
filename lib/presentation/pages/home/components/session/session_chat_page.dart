import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/models/session_messages_model.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/styles/styles.dart';

import '../../../../../state/data_state.dart';
import '../../../../../state/session_state.dart';
import '../../../../../styles/colors.dart';
import 'image_preview_page.dart';

class SessionChatPage extends ConsumerStatefulWidget {
  const SessionChatPage({super.key});

  @override
  ConsumerState<SessionChatPage> createState() => _SessionChatPageState();
}

class _SessionChatPageState extends ConsumerState<SessionChatPage> {
  String message = '';
  final TextEditingController _controller = TextEditingController();
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var uid = ref.watch(userProvider).id;
    var session = ref.watch(selectedSessionProvider);
    var selectedUser = ref.watch(selectedCounsellorStreamProvider(
        uid == session.userId ? session.counsellorId! : session.userId!));
    var sessionMessages = ref.watch(sessionMessagesStreamProvider(session.id!));

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'End Session',
                    child: Text('End Session'),
                  ),
                  const PopupMenuItem(
                    value: 'Report Counsellor',
                    child: Text('Report Counsellor'),
                  ),
                ];
              }),
          const SizedBox(width: 5)
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: uid == session.userId
                        ? session.counsellorImage != null
                            ? NetworkImage(session.counsellorImage!)
                            : null
                        : session.userImage != null
                            ? NetworkImage(session.userImage!)
                            : null),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      uid == session.userId
                          ? session.counsellorName!
                          : session.userName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          normalText(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    selectedUser.when(data: (data) {
                      if (data != null) {
                        String status = data.isOnline! ? 'Online' : 'Offline';
                        return Text(
                          status,
                          style: normalText(
                              color: status.toLowerCase() == 'online'
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12),
                        );
                      } else {
                        return const Text('');
                      }
                    }, loading: () {
                      return const SizedBox(
                          width: 150, child: LinearProgressIndicator());
                    }, error: (error, stackTrace) {
                      return const Text('');
                    })
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  session.topic!,
                  style: normalText(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: sessionMessages.when(data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No messages yet'));
              }
              return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var message = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: message.senderId == uid
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
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7),
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
                                    : message.type == 'image'
                                        ? Image.network(
                                            message.message!,
                                            height: 250,
                                            fit: BoxFit.cover,
                                          )
                                        : message.type == 'video'
                                            ? Text('Video')
                                            : Text('Audio')),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }, error: (error, stackTrace) {
              return Center(
                  child: Text(
                'Something went wrong',
                style: normalText(color: Colors.grey),
              ));
            }, loading: () {
              return const Center(
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator()));
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFields(
                    hintText: 'Type your message',
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isEmpty)
                          PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'audio') {
                                  sendMessages(type: 'audio', session: session);
                                } else if (value == 'image') {
                                  openSourceBottomSheet(context, value,
                                      session: session);
                                } else if (value == 'video') {
                                  sendMessages(type: 'video', session: session);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'audio',
                                    child: Row(
                                      children: [
                                        Icon(Icons.record_voice_over,
                                            color: primaryColor, size: 20),
                                        SizedBox(width: 5),
                                        Text('Record Audio'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'image',
                                    child: Row(
                                      children: [
                                        Icon(Icons.camera_alt_outlined,
                                            color: primaryColor, size: 20),
                                        SizedBox(width: 5),
                                        Text('Send Image'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'video',
                                    child: Row(
                                      children: [
                                        Icon(Icons.videocam_outlined,
                                            color: primaryColor, size: 20),
                                        SizedBox(width: 5),
                                        Text('Send Video'),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                color: primaryColor,
                                size: 20,
                              )),
                        if (message.isNotEmpty)
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                sendMessages(type: 'text', session: session);
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
        ],
      ),
    );
  }

  void sendMessages({String? type, required SessionModel session}) async {
    var uid = ref.watch(userProvider).id;
    var receiverId =
        uid == session.userId ? session.counsellorId! : session.userId;
    var receiverName =
        uid == session.userId ? session.counsellorName! : session.userName;
    var receiverImage =
        uid == session.userId ? session.counsellorImage! : session.userImage!;
    SessionMessagesModel messagesModel = SessionMessagesModel();
    messagesModel.message = message;
    messagesModel.type = type;
    messagesModel.senderId = uid;
    messagesModel.senderName = ref.watch(userProvider).name;
    messagesModel.senderImage = ref.watch(userProvider).profile;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
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
        _controller.clear();
        message = '';
      });
    }
  }

  void openSourceBottomSheet(BuildContext context, String value,
      {required SessionModel session}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    openImagePicker(
                        session: session, type: value, source: 'camera');
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    openImagePicker(
                        session: session, type: value, source: 'gallery');
                  },
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Gallery'),
                ),
              ],
            ),
          );
        });
  }

  void openImagePicker(
      {required SessionModel session,
      required String type,
      required String source}) async {
    if (source == 'camera') {
      XFile? media;
      if (type == 'image') {
        media = await picker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        //convert to file
        File file = File(media!.path);
        if (mounted) {
          sendToTransparentPage(context, ImagePreviewPage([file], session));
        }
      } else {
        media = await picker.pickVideo(
            source: ImageSource.camera,
            maxDuration: const Duration(seconds: 60));
        //convert to file
        File file = File(media!.path);
        if (mounted) {
          sendToTransparentPage(context, ImagePreviewPage([file], session));
        }
      }
    } else {
      // Pick multiple images and videos.
      final List<XFile> medias = await picker.pickMultipleMedia();
      // convert to files
      List<File> files = [];
      for (var media in medias) {
        files.add(File(media.path));
      }
      if (mounted) {
        sendToTransparentPage(context, ImagePreviewPage(files, session));
      }
    }
  }
}
