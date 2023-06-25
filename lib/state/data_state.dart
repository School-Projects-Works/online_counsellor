import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/functions.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/user_model.dart';
import '../presentation/home/home_main.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_fireStore.dart';
import '../services/firebase_storage.dart';
import 'navigation_state.dart';

final userProvider =
    StateNotifierProvider<UserProvider, UserModel>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel());

  void setUser(UserModel user) {
    state = user;
  }

  void setUserName(String value) {
    state = state.copyWith(name: value);
  }

  void setUserEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setUserPhone(String value) {
    state = state.copyWith(phone: value);
  }

  void setUserPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setUserGender(value) {
    state = state.copyWith(gender: value);
  }

  void setUserAddress(String value) {
    state = state.copyWith(address: value);
  }

  void setUserType(String type) {
    state = state.copyWith(userType: type);
  }

  void setDOB(String s) {
    state = state.copyWith(dob: s);
  }

  void createUser(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Creating User... Please wait');
    final userImage = ref.watch(userImageProvider);
    state = state.copyWith(createdAt: DateTime.now().millisecondsSinceEpoch);
    //create user in firebase auth
    final user = await FirebaseAuthService.createUserWithEmailAndPassword(
        state.email!, state.password!);
    if (user != null) {
      //send verification email
      await FirebaseAuthService.sendEmailVerification();
      state = state.copyWith(id: user.uid);
      //save user image to cloud storage
      if (userImage != null) {
        final userImageUrl = await CloudStorageServices.saveUserImage(
            userImage, state.id.toString());
        state = state.copyWith(profile: userImageUrl);
      }
      //save user to firestore
      final String response = await FireStoreServices.saveUser(state);
      if (response == 'success') {
        //? UPDATE user profile

        // clear all states
        ref.read(userProvider.notifier).state = UserModel();
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          title: 'Success',
          message:
              'User created successfully\n A verification email has been sent to your email address\n Please verify your email address to login',
        );
        ref.read(authIndexProvider.notifier).state = 1;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
          title: 'Error',
          message: response,
        );
      }
    }
  }

  void setUserRegion(String region) {
    state = state.copyWith(region: region);
  }

  void setUserCity(String s) {
    state = state.copyWith(city: s);
  }

  void setAbout(String s) {
    state = state.copyWith(about: s);
  }

  void setCounsellorType(String type) {
    state = state.copyWith(counsellorType: type);
  }

  void setMaritalStatus(param0) {}

  void setEducationLevel(param0) {}
}

final userSignInProvider = StateNotifierProvider<UserSignInProvider, User?>(
    (ref) => UserSignInProvider());

class UserSignInProvider extends StateNotifier<User?> {
  UserSignInProvider() : super(null);

  void setUser(User? user) {
    state = user;
  }

  void signIn(
      {required BuildContext context,
      required WidgetRef ref,
      required String email,
      required String password}) async {
    CustomDialog.showLoading(message: 'Signing In... Please wait');
    final user = await FirebaseAuthService.signIn(email, password);
    if (user != null) {
      state = user;
      if (user.emailVerified) {
        //get user from firestore
        final UserModel? userModel = await FireStoreServices.getUser(user.uid);
        if (userModel != null) {
          //set user to provider
          ref.read(userProvider.notifier).setUser(userModel);
          if (mounted) {
            noReturnSendToPage(context, const HomeMainPage());
          }
        } else {
          await FirebaseAuthService.signOut();
          CustomDialog.dismiss();
          CustomDialog.showError(
            title: 'Error',
            message: 'Could not retrieve user...Try again later ',
          );
        }
      } else {
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showInfo(
            title: 'Email not verified',
            message:
                'Please verify your email address to login.\n Do not have verification Link ?',
            onConfirmText: 'Send Link',
            onConfirm: () {
              FirebaseAuthService.sendEmailVerification();
              CustomDialog.dismiss();
            });
      }
    }
  }
}

final userImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);

final userTypeProvider = StateProvider<String?>((ref) => null);
final counsellorTypeProvider = StateProvider<String?>((ref) => null);
