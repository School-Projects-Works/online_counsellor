import 'package:flutter_riverpod/flutter_riverpod.dart';

final authIndexProvider = StateProvider<int>((ref) => 0);
final userSignUpPageIndexProvider = StateProvider<int>((ref) => 0);

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
