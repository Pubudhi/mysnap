import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/component/my_textfield.dart';
import 'package:mysnap/features/profile/domain/entity/profile_user.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_satate.dart';

import '../../../../responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //mobile image picker
  PlatformFile? imagePickedFile;

  //web image pick
  Uint8List? webImage;

  //controllers
  final bioTextController = TextEditingController();

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

  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    //prepare image and data

    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    } else {
      //noting to update go to previous page
      Navigator.pop(context);
    }
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      //profile loading
      if (state is ProfileLoading) {
        return const Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), Text('Uploading...')],
          ),
        ));
      } else {
        //edit form
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
        // appbar
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            //save btn
            IconButton(
                onPressed: updateProfile, icon: const Icon(Icons.upload)),
          ],
        ),
        body: Column(
          children: [
            // profile picture
            Center(
              child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      : (kIsWeb && webImage != null)
                          ? Image.memory(webImage!)
                          : CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
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
                              imageBuilder: (context, impageProvider) => Image(
                                  image: impageProvider, fit: BoxFit.cover),
                            )),
            ),

            const SizedBox(
              height: 10,
            ),

            Center(
                child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            )),

            //bio
            const Text('Bio'),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MyTextfield(
                  controller: bioTextController,
                  hintText: widget.user.bio,
                  obscureText: false),
            ),
          ],
        ));
  }
}
