import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:online_counsellor/presentation/pages/home/home_main.dart';
import 'package:online_counsellor/presentation/pages/authentication/auth_main_page.dart';
import 'package:online_counsellor/presentation/pages/home/pages/chart_page.dart';
import 'package:online_counsellor/services/firebase_auth.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'core/components/widgets/smart_dialog.dart';
import 'core/functions.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

//firebase meeageing handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<bool> _initUser() async {
    ref.watch(quotesProvider.notifier).getQuotes();
    ref.watch(counsellorsProvider.notifier).getCounsellors();
    // //get all uses from firestore and add update their rating with random number
    // List<Map<String, dynamic>> users = await FireStoreServices.getAllUsersMap();
    // for (Map<String, dynamic> user in users) {
    //   await FireStoreServices.updateUserRating(user['id'], getRandomRating());
    // }
    //await FirebaseAuthService.signOut();
    if (FirebaseAuthService.isUserLogin()) {
      User user = FirebaseAuthService.getCurrentUser();

      //set user isOnline to true in firestore
      await FireStoreServices.updateUserOnlineStatus(user.uid, true);
      UserModel? userModel = await FireStoreServices.getUser(user.uid);
      if (userModel != null) {
        ref.read(userProvider.notifier).setUser(userModel);
      } else {
        CustomDialog.showError(
            title: 'Data Error',
            message: 'Unable to get User info, try again later');
      }

      return true;
    } else {
      return false;
    }
  }
  // set user isOnline to false in firestore when app is closed

  @override
  void initState() {
    requestPermission();
    getToken();
    initLocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Online Counsellor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        builder: FlutterSmartDialog.init(),
        home: FutureBuilder<bool>(
            future: _initUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const HomeMainPage();
                } else {
                  return const AuthMainPage();
                }
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  ),
                );
              }
            }));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      ref.read(messageTokenProvider.notifier).state = value;
    });
  }

  void initLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var ios = const IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: android,
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'channel id',
                'channel name',
                channelDescription: 'channel description',
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    sendToPage(context, const ChatPage());
  }
}
