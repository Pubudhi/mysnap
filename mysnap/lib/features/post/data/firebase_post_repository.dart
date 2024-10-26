import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysnap/features/post/domain/entity/comment.dart';
import 'package:mysnap/features/post/domain/entity/post.dart';
import 'package:mysnap/features/post/domain/repository/post_repository.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  // store posts in collection called 'posts'
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      //convert firetore json to kist of posts
      await postCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting post $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapShot =
          await postCollection.orderBy('timestamp', descending: true).get();
      //convert firestore doc from json to posts
      final List<Post> allPosts = postsSnapShot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserID(String userId) async {
    try {
      final postSnapShot =
          await postCollection.where('userId', isEqualTo: userId).get();
      final userPosts = postSnapShot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error fetching user post by id  $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      //get the post doc from firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // check if the user already liked
        final hasLinked = post.likes.contains(userId);

        if (hasLinked) {
          //unikie
          post.likes.remove(userId);
        } else {
          //like
          post.likes.add(userId);
        }

        // update the postDoc
        await postCollection.doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error in toggling like $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get post document

      final postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        //add the new comment
        post.comments.add((comment));
        //update the firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()),
        });
      } else {
        throw Exception("Post now found");
      }
    } catch (e) {
      throw Exception("Error adding comment $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get post document
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //remove comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update the firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()),
        });
      } else {
        throw Exception("Post now found");
      }
    } catch (e) {
      throw Exception("Error adding comment $e");
    }
  }
}
