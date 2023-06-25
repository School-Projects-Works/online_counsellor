import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/navigation_state.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class AuthMainPage extends ConsumerWidget {
  const AuthMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
            body: IndexedStack(
      alignment: Alignment.center,
      index: ref.watch(authIndexProvider),
      children: const [LoginPage(), SignUpPage()],
    )));
  }
}
