import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/home/component/my_drawer.dart';
import 'package:mysnap/features/post/component/post_tile.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_states.dart';

import '../../../responsive/constrained_scaffold.dart';
import '../../post/presentation/page/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  //on start up
  @override
  void initState() {
    super.initState();

    // fetch all posts
    fetchAllPosts();
  }

  //fetch all posts
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  //delete post
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

// build UI
  @override
  Widget build(BuildContext context) {
    //scaffold
    return ConstrainedScaffold(
      //app bar
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload new post btn
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadPostPage())),
              icon: const Icon(Icons.add)),
        ],
      ),
      //drawer
      drawer: const MyDrawer(),

      //body
      body: BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
        // loading
        if (state is PostsLoading && state is PostsUploading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostsLoaded) {
          //loaded
          final allPosts = state.posts;
          if (allPosts.isEmpty) {
            return const Center(
              child: Text("No posts available"),
            );
          }
          return ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              final post = allPosts[index];

              return PostTile(
                post: post,
                onDeletePressed: () => deletePost(post.id),
              );
            },
          );
        }

        //error
        else if (state is PostsError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
