import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/component/my_textfield.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/post/component/comment_tile.dart';
import 'package:mysnap/features/post/domain/entity/comment.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_states.dart';
import 'package:mysnap/features/profile/domain/entity/profile_user.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mysnap/features/profile/presentation/page/profile_page.dart';

import '../../auth/domain/entity/app_user.dart';
import '../domain/entity/post.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //cubit
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //controllers
  final commentTextController = TextEditingController();

  //current user
  AppUser? currentUser;

  // user owns the post
  bool isOwnPost = false;

  //prfile(post) user
  ProfileUser? postUser;

  //on start up
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  // get current user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  // fetch current user
  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);

    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  ///
  /// Like
  ///

  //user tapped the like icon btn
  void toggleLikePost() {
    //current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // load optimize
    setState(() {
      if (isLiked) {
        //ulike
        widget.post.likes.remove(currentUser!.uid);
      } else {
        //like
        widget.post.likes.add(currentUser!.uid);
      }
    });

    //update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      //revert back to original like  count
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  ///
  /// Comment
  ///

  // open comment box when user wants to type a comment
  void openNewComment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextfield(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          //cancel btn
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          //save btn
          TextButton(
            onPressed: () => {
              addComment(),
              Navigator.of(context).pop(),
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  //add comment
  void addComment() {
    //create new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  //discpose controller
  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  //show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        actions: [
          // cancel btn
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel")),

          //delete tn
          TextButton(
              onPressed: () {
                widget.onDeletePressed!();
                Navigator.of(context).pop();
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(children: [
        //Top Section: profile pic, name, delete
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.post.userId),
              )),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // profile pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                      )
                    : const Icon(Icons.person),

                const SizedBox(
                  width: 10,
                ),
                //name
                Text(widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    )),

                const Spacer(),

                //delete btn
                if (isOwnPost)
                  GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      )),
              ],
            ),
          ),
        ),

        // image
        CachedNetworkImage(
          imageUrl: widget.post.imageUrl,
          height: 430,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(height: 430),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        //btn -> like, comment, timestamp
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    //like btn
                    GestureDetector(
                      onTap: toggleLikePost,
                      child: Icon(
                        widget.post.likes.contains(currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.post.likes.contains(currentUser!.uid)
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),

                    // post likes count
                    Text(widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),

              //comment button
              GestureDetector(
                  onTap: openNewComment,
                  child: const Icon(
                    Icons.comment,
                  )),

              const SizedBox(
                width: 5,
              ),

              Text(widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  )),

              const Spacer(),

              //timestamp
              Text(widget.post.timestamp.toString()),
            ],
          ),
        ),

        //caption

        //usr name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            children: [
              Text(widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),

        //comment section
        BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
          //loaded
          //print("comment section  $state");
          if (state is PostsLoaded) {
            final post =
                state.posts.firstWhere((post) => (post.id == widget.post.id));

            if (post.comments.isNotEmpty) {
              //how many comments to show
              int showCommentCount = post.comments.length;

              //comment-section
              return ListView.builder(
                itemCount: showCommentCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  //get comment by comment
                  final comment = post.comments[index];

                  //comment tile UI
                  return CommentTile(comment: comment);
                },
              );
            }
          }

          //loading
          if (state is PostsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );

            //error
          } else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        }),
      ]),
    );
  }
}
