import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysnap/features/profile/component/user_tile.dart';
import 'package:mysnap/features/search/presenation/cubit/search_states.dart';

import '../../../../responsive/constrained_scaffold.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    //listerning to each key strokes
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //build UI
  @override
  Widget build(BuildContext context) {
    //scaffold
    return ConstrainedScaffold(
      // App bar
      appBar: AppBar(
        //search text field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        centerTitle: true,
      ),

      //searched users
      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          //loaded
          if (state is SearchLoaded) {
            //no users
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            //users
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }

          //loaded
          else if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //error
          else if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          }

          //deafult
          return const Center(
            child: Text("Start searching users here...")
          );
        },
      ),
    );
  }
}
