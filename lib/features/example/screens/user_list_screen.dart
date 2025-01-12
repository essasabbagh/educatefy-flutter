// lib/screens/user_list_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/pagination/paginated_list_widget.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';
import '../widgets/user_list_item.dart';

/// Screen that displays the paginated list of users
class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Handles search input with debouncing
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        ref.read(userParamsProvider.notifier).state =
            ref.read(userParamsProvider).copyWith(query: query, page: 1);
        ref.read(userListProvider.notifier).refresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final params = ref.watch(userParamsProvider);

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Users'),
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            // prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon:
                        const Icon(Icons.clear_rounded, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String order) {
              final isAsc = params.sortDirection == 'asc';
              ref.read(userParamsProvider.notifier).state = params.copyWith(
                orderBy: order,
                sortDirection: isAsc ? 'desc' : 'asc',
                page: 1,
              );
              ref.read(userListProvider.notifier).refresh();
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    const Icon(Icons.sort_by_alpha),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by name ${params.orderBy == 'name' ? (params.sortDirection == 'asc' ? '↑' : '↓') : ''}',
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'email',
                child: Row(
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by email ${params.orderBy == 'email' ? (params.sortDirection == 'asc' ? '↑' : '↓') : ''}',
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'role',
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Role ${params.orderBy == 'role' ? (params.sortDirection == 'asc' ? '↑' : '↓') : ''}',
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: Row(
                  children: [
                    const Icon(Icons.security_update_good_sharp),
                    const SizedBox(width: 8),
                    Text(
                        'Sort by Status ${params.orderBy == 'status' ? (params.sortDirection == 'asc' ? '↑' : '↓') : ''}'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(userListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: PaginatedListWidget<User>(
        provider: userListProvider,
        itemBuilder: (context, user) => UserListItem(user: user),
      ),
    );
  }
}
