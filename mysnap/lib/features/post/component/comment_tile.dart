import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/domain/entity/app_user.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';

import '../domain/entity/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({
    required this.comment,
    super.key,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
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

          //delete btn
          TextButton(
              onPressed: () {
                context
                    .read<PostCubit>()
                    .deleteComment(widget.comment.postId, widget.comment.id);
                Navigator.of(context).pop();
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //comment tile UI
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          //name
          Text(
            widget.comment.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(
            width: 10,
          ),

          //comment text
          Text(widget.comment.text),

          const Spacer(),

          //delete btn
          if (isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
        ],
      ),
    );
  }
}
