import 'package:clock/clock.dart';
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
  late FocusNode _searchFocus;

  @override
  void initState() {
    _isSearching = false;
    _searchFocus = FocusNode();
    super.initState();
  }

  void _openSearch() {
    setState(() {
      _isSearching = true;
    });
    // workaroung to get it working
    Future.delayed(
      const Duration(milliseconds: 50),
      () => FocusScope.of(context).requestFocus(_searchFocus),
    );
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
              focusNode: _searchFocus,
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
        BlocBuilder<ApodListCubit, ApodListState>(
          builder: (context, state) {
            return IconButton(
              // adding key to prevent Flutter from
              // showing ripple effect on wrong button
              key: GlobalKey(),
              onPressed: () {
                _showDateRange(state.dateRange);
              },
              icon: const Icon(Icons.calendar_today),
            );
          },
        ),
      ],
    );
  }

  void _showDateRange(DateTimeRange? initialDateRange) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final dateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(1995, 6, 16),
      lastDate: clock.now().add(const Duration(days: 1)),
    );

    if (dateRange != null && mounted) {
      context.read<ApodListCubit>().filter(dateRange);
    }
  }
}
