import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:online_counsellor/presentation/pages/home/home_main.dart';
import 'package:online_counsellor/presentation/pages/authentication/auth_main_page.dart';
import 'package:online_counsellor/services/firebase_auth.dart';
import 'package:online_counsellor/services/firebase_fireStore.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/colors.dart';
import 'core/components/widgets/smart_dialog.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('BOOT: before Firebase.initializeApp');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('BOOT: after Firebase.initializeApp, calling runApp');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final Future<bool> _initUserFuture;

  static const _initTimeout = Duration(seconds: 10);

  Future<bool> _initUser() async {
    debugPrint('INIT: _initUser start');
    ref.read(quotesProvider.notifier).getQuotes();
    ref.read(counsellorsProvider.notifier).getCounsellors();
    //await FirebaseAuthService.signOut();
    if (!FirebaseAuthService.isUserLogin()) {
      debugPrint('INIT: no user logged in, going to auth page');
      return false;
    }
    try {
      User user = FirebaseAuthService.getCurrentUser();
      debugPrint('INIT: user logged in as ${user.uid}, updating online status');
      await FireStoreServices.updateUserOnlineStatus(user.uid, true)
          .timeout(_initTimeout);
      debugPrint('INIT: online status updated, fetching user doc');
      UserModel? userModel =
          await FireStoreServices.getUser(user.uid).timeout(_initTimeout);
      debugPrint('INIT: getUser returned ${userModel == null ? 'null' : 'a user'}');
      if (userModel != null) {
        ref.read(userProvider.notifier).setUser(userModel);
        return true;
      } else {
        CustomDialog.showError(
            title: 'Data Error',
            message: 'Unable to get User info, try again later');
        return false;
      }
    } catch (e) {
      debugPrint('INIT: _initUser failed with error: $e');
      CustomDialog.showError(
          title: 'Data Error',
          message: 'Unable to get User info, try again later');
      return false;
    }
  }
  // set user isOnline to false in firestore when app is closed

  @override
  void initState() {
    super.initState();
    _initUserFuture = _initUser();
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
            future: _initUserFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!) {
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
}
