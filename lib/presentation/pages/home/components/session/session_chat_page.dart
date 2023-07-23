import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/models/session_messages_model.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:online_counsellor/presentation/pages/home/components/session/message_item.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/styles/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../../../../../state/data_state.dart';
import '../../../../../state/session_state.dart';
import '../../../../../styles/colors.dart';
import 'audio_Record_Page.dart';
import 'image_preview_page.dart';
import 'package:record/record.dart';

class SessionChatPage extends ConsumerStatefulWidget {
  const SessionChatPage({super.key});

  @override
  ConsumerState<SessionChatPage> createState() => _SessionChatPageState();
}

class _SessionChatPageState extends ConsumerState<SessionChatPage> {
  String message = '';
  final TextEditingController _controller = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final record = Record();
  //create timer
  Timer? timer;

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
                  return MessageItem(
                    message: message,
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
                      width: 45,
                      height: 45,
                      child: CircularProgressIndicator()));
            }),
          ),
          if (session.status == 'Ended')
            Center(
                child: Text(
              'Session has ended',
              style:
                  normalText(color: primaryColor, fontWeight: FontWeight.bold),
            )),
          if (session.status != 'Ended')
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
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  openSourceBottomSheet(context,
                                      session: session);
                                },
                                icon: const Icon(Icons.image,
                                    color: primaryColor, size: 25)),
                          if (message.isEmpty)
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  //show bottom sheet for recording
                                  sendToTransparentPage(
                                      context, const AudioRecordPage());
                                },
                                icon: Icon(MdiIcons.microphoneMessage,
                                    color: primaryColor, size: 25)),
                          if (message.isNotEmpty)
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  sendMessages(type: 'text', session: session);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: primaryColor,
                                  size: 25,
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

  void openSourceBottomSheet(BuildContext context,
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
                    openImagePicker(session: session, source: 'camera');
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    openImagePicker(session: session, source: 'gallery');
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
      {required SessionModel session, required String source}) async {
    XFile? media;
    if (source == 'camera') {
      media =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (media == null) return;
      //convert to file
      File file = File(media.path);
      if (mounted) {
        sendToTransparentPage(context, ImagePreviewPage(file, session));
      }
    } else {
      // Pick multiple images and videos.
      media =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (media == null) return;
      //convert to file
      File file = File(media.path);
      if (mounted) {
        sendToTransparentPage(context, ImagePreviewPage(file, session));
      }
    }
  }
}
