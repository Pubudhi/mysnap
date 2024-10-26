import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    required this.onPressed,
    required this.isFollowing,
    super.key,
  });

  // build UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding outside
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          //btn
          onPressed: onPressed,
          //padding inside
          padding: const EdgeInsets.all(25),
          //color
          color:
              isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          //text
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
