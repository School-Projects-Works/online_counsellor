import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/presentation/pages/home/components/session/session_item.dart';
import 'package:online_counsellor/state/session_state.dart';
import 'package:online_counsellor/styles/styles.dart';
import '../../../../../styles/colors.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key});

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var sessions = ref.watch(sessionsStreamProvider);
    return SafeArea(
        child: Scaffold(
            body: sessions.when(
                data: (data) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: CustomTextFields(
                      controller: _controller,
                      hintText: 'search session',
                      focusNode: _focus,
                      suffixIcon: _focus.hasFocus
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  ref.read(sessionSearchQuery.notifier).state =
                                      '';
                                  _focus.unfocus();
                                });
                              },
                              icon: Icon(MdiIcons.close, color: primaryColor))
                          : Icon(MdiIcons.magnify, color: primaryColor),
                      onChanged: (value) {
                        ref.read(sessionSearchQuery.notifier).state = value;
                      },
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: _focus.hasFocus
                          ? ListView.builder(itemBuilder: (context, index) {
                              return ListTile();
                            })
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var session = data[index];
                                return SessionItem(session);
                              }),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: normalText(color: Colors.grey),
                    ),
                  );
                },
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))));
  }
}
