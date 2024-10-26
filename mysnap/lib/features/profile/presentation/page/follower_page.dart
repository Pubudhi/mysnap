import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/profile/component/user_tile.dart';
import 'package:mysnap/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> followings;

  const FollowerPage({
    required this.followers,
    required this.followings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: AppBar(
          //tab bar
          bottom: TabBar(
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: "Followers"),
                Tab(text: "Following"),
              ]),
        ),
        body: TabBarView(children: [
          _buildUserList(followers, "No Followers", context),
          _buildUserList(followings, "No Following", context),
        ]),
      ),
    );
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              //get each uid
              final uid = uids[index];
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  //loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  }

                  //loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("Loading..."),
                    );
                  }
                  //not found
                  else {
                    return ListTile(
                      title: Text("User not found."),
                    );
                  }
                },
              );
            },
          );
  }
}