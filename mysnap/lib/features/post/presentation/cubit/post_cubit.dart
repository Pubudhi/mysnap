import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/post/domain/repository/post_repository.dart';
import 'package:mysnap/features/post/presentation/cubit/post_states.dart';
import 'package:mysnap/features/storage/domain/storage_repository.dart';

import '../../domain/entity/comment.dart';
import '../../domain/entity/post.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostsInitial());

  // create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      //image upload for mobile platforms(using file path)
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        //image upload for web platforms(using file bytes)
        emit(PostsUploading());
        imageUrl =
            await storageRepository.uploadPostImageWeb(imageBytes, post.id);
      }

      //assign image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      postRepository.createPost(newPost);

      //re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to create post $e"));
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepository.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts $e"));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepository.deletePost(postId);
    } catch (e) {
      emit(PostsError("Failed to delete post $e"));
    }
  }

  //toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepository.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like $e"));
    }
  }

  //add comment to post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepository.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment $e"));
    }
  }

  //delete comment to post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment $e"));
    }
  }
}
