import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_apod/bloc/apod_list_cubit.dart';

class ApodSearchBar extends StatefulWidget implements PreferredSizeWidget {
  const ApodSearchBar({super.key});

  @override
  State<ApodSearchBar> createState() => _ApodSearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ApodSearchBarState extends State<ApodSearchBar> {
  late bool _isSearching;

  @override
  void initState() {
    _isSearching = false;
    super.initState();
  }

  void _openSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
    });
    _search('');
  }

  void _search(String query) {
    context.read<ApodListCubit>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              onChanged: _search,
              decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closeSearch,
                  )),
            )
          : const Text('Apods'),
      actions: [
        if (!_isSearching)
          IconButton(
            key: GlobalKey(),
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
          ),
        IconButton(
          // adding key to prevent Flutter from
          // showing ripple effect on wrong button
          key: GlobalKey(),
          onPressed: () {},
          icon: const Icon(Icons.calendar_today),
        ),
      ],
    );
  }
}
