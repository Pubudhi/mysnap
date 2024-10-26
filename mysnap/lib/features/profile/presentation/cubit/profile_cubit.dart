import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/profile/domain/entity/profile_user.dart';
import 'package:mysnap/features/profile/domain/repository/profile_repository.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_satate.dart';
import 'package:mysnap/features/storage/domain/storage_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  ProfileCubit(
      {required this.profileRepository, required this.storageRepository})
      : super(ProfileInitial());

  //fetch user profile using repo / sigle profile page loading
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepository.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      //todo: implement
      emit(ProfileError(e.toString()));
    }
  }

  //fetch user profile using repo / may profiles loading
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepository.fetchUserProfile(uid);
    return user;
  }

  //update bio or profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      //fetch current profile
      final currentUser = await profileRepository.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch the user for profile update"));
        return;
      }

      //update profile pic
      String? imageDownloadUrl;

      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepository.uploadProfileImageMobile(
              imageMobilePath, uid);
        } else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepository.uploadProfileImageWeb(imageWebBytes, uid);
        }
      }

      if (imageDownloadUrl == null) {
        emit(ProfileError("failed to upload image"));
        return;
      }

      //update new profile
      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl,
      );

      // update repo
      await profileRepository.updateProfile(updateProfile);

      //re-fetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }

  //toggle follow/Unfollow
  Future<void> toggleFlollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepository.toggleFollow(currentUserId, targetUserId);
    } catch (e) {
      emit(ProfileError("Error toggling follow $e"));
    }
  }
}
