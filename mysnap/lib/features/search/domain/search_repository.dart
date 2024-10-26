import 'package:mysnap/features/profile/domain/entity/profile_user.dart';

abstract class SearchRepository {
  Future<List<ProfileUser?>> searchUsers(String query);
}
