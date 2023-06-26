import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';
import 'package:online_counsellor/models/user_model.dart';
import 'package:online_counsellor/state/data_state.dart';

class CounsellorViewPage extends ConsumerWidget {
  const CounsellorViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? counsellor = ref.watch(selectedCounsellorProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    child: CustomButton(
                      color: Colors.red,
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: MdiIcons.closeBox,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (counsellor!.profile != null)
                Image.network(
                  counsellor.profile!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              const SizedBox(height: 10),
              Text(counsellor.counsellorType.toString().toUpperCase(),
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(counsellor.name.toString(),
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Divider()
            ]),
      ),
    );
  }
}
