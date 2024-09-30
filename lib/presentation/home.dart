import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cubit_project/util/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/app_user.dart';
import '../di/module.dart';
import '../logic/auth/auth_cubit.dart';
import '../logic/auth/auth_state.dart';
import '../logic/firestore/firestore_cubit.dart';
import '../logic/firestore/firestore_state.dart';
import '../logic/notification/notification_cubit.dart';
import '../logic/notification/notification_state.dart';
import '../logic/storage/storage_cubit.dart';
import '../logic/storage/storage_state.dart';
import '../util/firebase_message_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.navigateTo("/login");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: logout, child: const Text('Log Out'))
          ],
        ),
        body: Column(
          children: [
            _buildFirestoreSection(context),
            _buildStorageSection(context),
            const Divider(),
            _buildRealTimeDBButtons(),
            const Divider(),
            _buildFireStoreButtons(),
            const Divider(),
            _buildImageUploadButton(),
            const Divider(),
            _buildNotificationSection()
          ],
        ),
      ),
    );
  }

  Widget _buildFirestoreSection(BuildContext context) {
    return BlocConsumer<FirestoreCubit, FirestoreState>(
      listener: (context, state) {
        if (state is DataSaved) {
          context.showSnackBar('Data Saved');
        } else if (state is DataDeleted) {
          context.showSnackBar('Data Deleted');
        } else if (state is Failure) {
          context.showSnackBar(state.message);
        } else if (state is DataUpdated) {
          context.showSnackBar('User data updated');
        }
      },
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DataViewed) {
          return Center(
            child: Text(state.appUser.toString()),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildStorageSection(BuildContext context) {
    return BlocConsumer<StorageCubit, StorageState>(
      builder: (context, state) {
        if (state is FileUploaded) {
          return Image.network(
            state.downloadUrl,
            width: 200,
          );
        } else if (state is UploadFileLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
      listener: (context, state) {
        if (state is FileUploaded) {
          _updateUserData(state.downloadUrl);
          context.showSnackBar('File Uploaded');
        } else if (state is UploadFileFailure) {
          context.showSnackBar(state.message);
        }
      },
    );
  }

  Widget _buildRealTimeDBButtons() {
    return Column(
      children: [
        _buildButton('Save User Data in RealTimeDB', () {}),
        _buildButton('View User Data in RealTimeDB', () {}),
        _buildButton('Delete User Data in RealTimeDB', () {}),
      ],
    );
  }

  Widget _buildFireStoreButtons() {
    return Column(
      children: [
        _buildButton('Save User Data in FireStore', _saveUserData),
        _buildButton('View User Data in FireStore', viewUserData),
        _buildButton('Delete User Data in FireStore', _deleteUser),
      ],
    );
  }

  Widget _buildImageUploadButton() {
    return _buildButton('Upload Image', _uploadImage);
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void logout() {
    getIt<AuthCubit>().logoutUser();
  }

  Future<void> _saveUserData() async {
    try {
      final user = _getCurrentUser();
      AppUser appUser = AppUser(
        uid: user.uid,
        email: user.email!,
        address: 'Mansoura',
        phone: '12354452',
      );
      await getIt<FirestoreCubit>().saveUserData(appUser);
    } catch (e) {
      // Handle any error here
    }
  }

  Future<void> viewUserData() async {
    try {
      final user = _getCurrentUser();
      await getIt<FirestoreCubit>().viewUserData(user.uid);
    } catch (e) {
      // Handle any error here
    }
  }

  Future<void> _deleteUser() async {
    try {
      final user = _getCurrentUser();
      await getIt<FirestoreCubit>().deleteUserData(user.uid);
    } catch (e) {
      // Handle any error here
    }
  }

  void _uploadImage() {
    final user = _getCurrentUser();
    getIt<StorageCubit>().uploadFile(user.uid);
  }

  void _updateUserData(String downloadUrl) {
    final user = _getCurrentUser();
    getIt<FirestoreCubit>().updateUserData(user.uid, downloadUrl);
  }

  User _getCurrentUser() {
    return getIt<FirebaseAuth>().currentUser!;
  }

  Widget _buildNotificationSection() {
    return BlocConsumer<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Container();
      },
      listener: (context, state) {
        if (state is NotificationReceived) {
          FirebaseMessageService().showLocalNotification(state.message);
          context.showSnackBar(
              'Notification Received: ${state.message.notification!.title} - ${state.message.notification!.body}');
        } else if (state is NotificationPayloadReceived) {
          context
              .showSnackBar('Notification Payload Received: ${state.payload}');
        } else if (state is NotificationError) {
          context.showSnackBar(state.message);
        }
      },
    );
  }
}
