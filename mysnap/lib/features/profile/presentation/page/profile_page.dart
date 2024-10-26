import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/domain/entity/app_user.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_states.dart';
import 'package:mysnap/features/profile/component/bio_box.dart';
import 'package:mysnap/features/profile/component/follow_button.dart';
import 'package:mysnap/features/profile/component/profile_stats.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_satate.dart';
import 'package:mysnap/features/profile/presentation/page/follower_page.dart';

import '../../../../responsive/constrained_scaffold.dart';
import '../../../post/component/post_tile.dart';
import '../cubit/profile_cubit.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubit
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  //posts
  int postCount = 0;

  //on startup
  @override
  void initState() {
    super.initState();

    //load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  /// follow/unfollow
  void followButtionPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      //when profile is not loaded, wait
      return;
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    //optimize UI update
    setState(() {
      //unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        //follow
        profileUser.followers.add(currentUser!.uid);
      }
    });
    // perform actual toggle in cubit
    profileCubit
        .toggleFlollow(currentUser!.uid, widget.uid)
        .catchError((error) {
      //revert changes

      //unfollow -> follow
      if (isFollowing) {
        profileUser.followers.add(currentUser!.uid);
      } else {
        //follow -> unfollow
        profileUser.followers.remove(currentUser!.uid);
      }
    });
  }

  //build UI
  @override
  Widget build(BuildContext context) {
    //is own post
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      //loaded
      if (state is ProfileLoaded) {
        //get loaded user
        final user = state.profileUser;

        return ConstrainedScaffold(
          // appbar
          appBar: AppBar(
            title: Text(user.name),
            centerTitle: true,
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              //edit profile btn (can only edit if current is the owner of the acc)
              if (isOwnPost)
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          user: user,
                        ),
                      )),
                  icon: const Icon(Icons.settings),
                )
            ],
          ),
          // body
          body: ListView(
            children: [
              //email
              Center(
                child: Text(
                  user.email,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //profile pic
              CachedNetworkImage(
                imageUrl: user.profileImageUrl,
                //loading
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),

                //error
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),

                //loaded
                imageBuilder: (context, impageProvider) => Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: impageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //profile stats
              ProfileStats(
                postCount: postCount,
                followerCount: user.followers.length,
                followingCount: user.followings.length,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowerPage(
                        followers: user.followers,
                        followings: user.followings,
                      ),
                    )),
              ),

              const SizedBox(
                height: 25,
              ),

              //following btn (can only follow others)
              if (!isOwnPost)
                FollowButton(
                  onPressed: followButtionPressed,
                  isFollowing: user.followers.contains(currentUser!.uid),
                ),

              //bio
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      "Bio",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              BioBox(text: user.bio),

              const SizedBox(
                height: 10,
              ),

              //posts
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      "Posts",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // list of posts from the current user
              BlocBuilder<PostCubit, PostStates>(
                builder: (context, state) {
                  //posts loaded
                  if (state is PostsLoaded) {
                    //filter posts by the user id
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();

                    postCount = userPosts.length;

                    return ListView.builder(
                      itemCount: postCount,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // get post by post
                        final post = userPosts[index];
                        return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id));
                      },
                    );
                  }

                  //posts loading
                  else if (state is PostsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(
                      child: Text("No Posts..."),
                    );
                  }
                },
              )
            ],
          ),
        );
      }
      //loading
      else if (state is ProfileLoading) {
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      } else {
        return const Text("No profile found");
      }
    });
  }
}
