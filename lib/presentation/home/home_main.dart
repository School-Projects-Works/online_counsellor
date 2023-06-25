import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../generated/assets.dart';
import '../../state/navigation_state.dart';
import '../../styles/colors.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainState();
}

class _HomeMainState extends ConsumerState<HomeMainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          MdiIcons.home,
          MdiIcons.calendar,
          MdiIcons.chat,
          MdiIcons.account,
        ],
        activeIndex: ref.watch(bottomNavIndexProvider),
        gapLocation: GapLocation.center,
        activeColor: primaryColor,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,
        //other params
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Row(children: [
            Image.asset(Assets.logoIcon, width: 50, height: 50),
            const SizedBox(width: 10),
            Text("Online Counsellor",
                style: GoogleFonts.lobster(fontSize: 35, color: primaryColor))
          ]),
          subtitle: ref.watch(bottomNavIndexProvider) == 0
              ? const Center(child: Text("Home Page"))
              : ref.watch(bottomNavIndexProvider) == 1
                  ? const Center(
                      child: Text("Appointment Page"),
                    )
                  : ref.watch(bottomNavIndexProvider) == 2
                      ? const Center(
                          child: Text("Chat Page"),
                        )
                      : ref.watch(bottomNavIndexProvider) == 3
                          ? const Center(
                              child: Text("Profile Page"),
                            )
                          : Container(),
        ),
      ),
    ));
  }
}
