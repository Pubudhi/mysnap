import 'package:mysnap/features/post/domain/entity/comment.dart';
import 'package:mysnap/features/post/domain/entity/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostsByUserID(String userId);
  Future<void> toggleLikePost(String  postId, String userId);
  Future<void> addComment(String  postId, Comment comment);
  Future<void> deleteComment(String  postId, String commentId);
}