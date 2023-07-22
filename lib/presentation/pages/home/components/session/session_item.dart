import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:online_counsellor/presentation/pages/home/components/session/session_chat_page.dart';
import '../../../../../core/functions.dart';
import '../../../../../state/data_state.dart';
import '../../../../../state/session_state.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';
import 'package:badges/badges.dart' as badges;

class SessionItem extends ConsumerWidget {
  const SessionItem(this.session, {super.key});
  final SessionModel session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userId = ref.watch(userProvider).id;
    var selectedUser = ref.watch(selectedCounsellorStreamProvider(
        userId == session.userId ? session.counsellorId! : session.userId!));
    var sessionMessages = ref.watch(sessionMessagesStreamProvider(session.id!));
    return InkWell(
      onTap: () {
        ref.read(selectedSessionProvider.notifier).setSelectedSession(session);
        sendToPage(context, const SessionChatPage());
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 15),
        color: primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
                backgroundImage: userId == session.userId
                    ? session.counsellorImage != null
                        ? NetworkImage(session.counsellorImage!)
                        : null
                    : session.userImage != null
                        ? NetworkImage(session.userImage!)
                        : null),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    userId == session.userId
                        ? session.counsellorName!
                        : session.userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        normalText(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
            trailing: LayoutBuilder(builder: (context, constraints) {
              return sessionMessages.when(data: (data) {
                // get data where is not read
                var unreadMessages = data
                    .where((element) =>
                        element.senderId != userId && element.isRead == false)
                    .toList();
                if (unreadMessages.isNotEmpty) {
                  return badges.Badge(
                    badgeContent: Text(
                      unreadMessages.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.comment,
                        size: 18,
                      ),
                    ),
                  );
                } else {
                  return const Text('');
                }
              }, error: (error, stackTrace) {
                return const Text('');
              }, loading: () {
                return const Text('');
              });
            }),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.topic!),
                    Text(
                      getNumberOfTime(session.createdAt!),
                      style: normalText(fontSize: 13, color: Colors.grey),
                    )
                  ],
                ),
                Text(
                  session.status!,
                  style: normalText(
                      color: session.status!.toLowerCase() == 'ended'
                          ? Colors.red
                          : session.status!.toLowerCase() == 'pending'
                              ? Colors.grey
                              : primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
