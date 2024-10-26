import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mysnap/features/home/component/my_drawer_tile.dart';
import 'package:mysnap/features/settings/presentation/page/setting_page.dart';

import '../../profile/presentation/page/profile_page.dart';
import '../../search/presenation/page/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // logo tile
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                //home tile
                MyDrawerTile(
                  title: "H o m e",
                  icon: Icons.home,
                  onTap: () => Navigator.of(context).pop(),
                ),

                //profile tile
                MyDrawerTile(
                    title: "P r o f i l e",
                    icon: Icons.person,
                    onTap: () {
                      //pop menu drawer
                      Navigator.of(context).pop();

                      //get current user id
                      final user = context.read<AuthCubit>().currentUser;

                      String? uid = user!.uid;
                      // String? email = user.email;

                      //navigating profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: uid),
                        ),
                      );
                    }),

                //search tile
                MyDrawerTile(
                  title: "S e a r c h",
                  icon: Icons.search,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      )),
                ),

                //settings
                MyDrawerTile(
                  title: "S e t t i n g s",
                  icon: Icons.settings,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      )),
                ),

                const Spacer(),

                //logout
                MyDrawerTile(
                    title: "L o g o u t",
                    icon: Icons.logout,
                    onTap: () => context.read<AuthCubit>().logout()),
              ],
            ),
          ),
        ));
  }
}
