// lib/providers/user_providers.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/pagination/models/pagination_params.dart';
import '../../../core/pagination/models/pagination_state.dart';
import '../../../core/pagination/notifiers/paginated_list_notifier.dart';
import '../models/user.dart';
import '../services/user_service.dart';

/// Provider for the UserService instance
final userServiceProvider = Provider((ref) => UserService());

/// Provider for managing pagination parameters
final userParamsProvider = StateProvider<PaginationParams>((ref) {
  return const PaginationParams();
});

/// Provider for managing the paginated list of users
final userListProvider = StateNotifierProvider.autoDispose<
    PaginatedListNotifier<User>, PaginationState<User>>((ref) {
  final userService = ref.watch(userServiceProvider);
  final params = ref.watch(userParamsProvider);

  return PaginatedListNotifier<User>(
    fetchData: (page) => userService.getUsers(params.copyWith(page: page)),
    itemsPerPage: params.limit,
  );
});
