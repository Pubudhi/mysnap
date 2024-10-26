import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysnap/features/profile/domain/entity/profile_user.dart';
import 'package:mysnap/features/profile/domain/repository/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // print("User uid: ${uid}");

      // get user from firestore
      final userDoc = await firebaseFireStore
          .collection("users")
          .doc(uid)
          .get(const GetOptions(source: Source.server));
      // // Log the entire document snapshot object
      // print("Raw User Document: ${userDoc.toString()}");
      // print("Document Exists: ${userDoc.exists}");
      // print("Document Metadata: ${userDoc.metadata.toString()}");

      // print("User Data: ${userDoc.data()}");

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          // fetch followers and followings
          final followers = List<String>.from(userData['followers'] ?? []);
          final followings = List<String>.from(userData['followings'] ?? []);

          return ProfileUser(
            uid: uid,
            email: userData['email'] ?? '',
            name: userData['name'] ?? '',
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            followings: followings,
          );
        }
      }
      return null;
    } catch (e) {
      //todo: implement exceptions
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFireStore
          .collection("users")
          .doc(updateProfile.uid)
          .update({
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFireStore.collection('users').doc(currentUid).get();
      final targetUserDoc =
          await firebaseFireStore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          // check if the current user is already following the target user
          if (currentFollowing.contains(targetUid)) {
            //unfollow
            await firebaseFireStore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });

             await firebaseFireStore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            //follow
            await firebaseFireStore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });

             await firebaseFireStore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Error in toggle following $e");
    }
  }
}
