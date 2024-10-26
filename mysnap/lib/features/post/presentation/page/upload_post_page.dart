import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/component/my_textfield.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/post/domain/entity/post.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';
import 'package:mysnap/features/post/presentation/cubit/post_states.dart';

import '../../../../responsive/constrained_scaffold.dart';
import '../../../auth/domain/entity/app_user.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // controller
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create and upload post
  void uploadPost() {
    //check if both image and caption are provide
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Both image and caption are required")));
      return;
    }

    // create a new post obj
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      //mobile upload
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    //bloc consumer
    return BlocConsumer<PostCubit, PostStates>(builder: (context, state) {

      //loading or uploading
      if (state is PostsLoading || state is PostsUploading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // build upload page
      return buildUploadPage();
    },
        // go to prev page when upload is done and post are loaded
        listener: (context, state) {
      if (state is PostsLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildUploadPage() {
    // scaffold
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        centerTitle: true,
        actions: [
          // upload btn
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload))
        ],
      ),

      //body
      body: Center(
        child: Column(
          children: [
            // image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // pick image btn
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),

            //caption text box
            MyTextfield(
                controller: textController,
                hintText: "Caption",
                obscureText: false)
          ],
        ),
      ),
    );
  }
}
