import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/data/firebase_auth_repository.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_states.dart';
import 'package:mysnap/features/auth/presentation/page/auth_page.dart';
import 'package:mysnap/features/home/presentation/home_page.dart';
import 'package:mysnap/features/post/data/firebase_post_repository.dart';
import 'package:mysnap/features/post/presentation/cubit/post_cubit.dart';
import 'package:mysnap/features/profile/data/firebase_profile_repository.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mysnap/features/search/data/firebase_search_repository.dart';
import 'package:mysnap/features/search/presenation/cubit/search_cubit.dart';
import 'package:mysnap/theme/cubit/theme_cubit.dart';

import 'features/storage/data/firbase_storage_repository.dart';

/// root level of the app
/// repositores for db
/// - firebase
///
/// bloc providers for state mgt
/// - auth
/// - profile
/// - post
/// - search
/// - theme
///
/// check the auth state
/// - unauthenticated - auth page
/// - authenticated - home page
///

class MyApp extends StatelessWidget {
  // repo
  final firebaseAuthRepository = FirebaseAuthRepository();
  final firebaseProfileRepository = FirebaseProfileRepository();
  final storageRepository = FirbaseStorageRepository();
  final firebasePostRepository = FirebasePostRepository();
  final firebaseSearchRepository = FirebaseSearchRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///provide cubit to app
    return MultiBlocProvider(
        providers: [
          // auth cubit
          BlocProvider<AuthCubit>(
              create: (context) =>
                  AuthCubit(authRepository: firebaseAuthRepository)
                    ..checkAuth()),

          //profile cubit
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
                profileRepository: firebaseProfileRepository,
                storageRepository: storageRepository),
          ),

          //post cubit
          BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                postRepository: firebasePostRepository,
                storageRepository: storageRepository),
          ),

          //search cubit
          BlocProvider<SearchCubit>(
            create: (context) =>
                SearchCubit(searchRepository: firebaseSearchRepository),
          ),

          //theme cubit
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
        ],
        // bloc builder for themes
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, currentTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: currentTheme,
            //bloc builder for check current auth state
            home: BlocConsumer<AuthCubit, AuthStates>(
                builder: (context, authStates) {
              // print(authStates);
              // unauthenticated -> auth page
              if (authStates is UnAuthenticated) {
                return const AuthPage();
              }

              //authenticated -> home page
              if (authStates is Authenticated) {
                return const HomePage();
              }

              //loding
              else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },

                // any error
                listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            }),
          ),
        ));
  }
}
