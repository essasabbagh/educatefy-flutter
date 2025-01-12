import 'package:flutter/material.dart';


import '../../../core/pagination/models/pagination_params.dart';
import '../models/user.dart';

/// Service class for handling user-related API operations.
class UserService {
  /// Fetches users based on the provided pagination parameters.
  ///
  /// This is a mock implementation that simulates API behavior.
  /// In a real application, this would make actual API calls.
  Future<List<User>> getUsers(PaginationParams params) async {
    // Simulate network delay
    await Future.delayed(Durations.extralong4);

    // Generate mock data
    List<User> users = List.generate(
      params.limit,
      (index) {
        final id = (params.page - 1) * params.limit + index;
        final roles = ['admin', 'user', 'manager'];
        final statuses = ['active', 'inactive', 'pending'];

        return User(
          id: id,
          name: 'User $id',
          email: 'user$id@example.com',
          avatarUrl: 'https://i.pravatar.cc/150?img=$id',
          role: roles[id % roles.length],
          status: statuses[id % statuses.length],
        );
      },
    );

    // Apply search filter
    if (params.query != null && params.query!.isNotEmpty) {
      users = users
          .where((user) =>
              user.name.toLowerCase().contains(params.query!.toLowerCase()) ||
              user.email.toLowerCase().contains(params.query!.toLowerCase()))
          .toList();
    }

    // Apply role/status filters
    if (params.filters != null) {
      if (params.filters!['role'] != null) {
        users = users
            .where((user) => user.role == params.filters!['role'])
            .toList();
      }
      if (params.filters!['status'] != null) {
        users = users
            .where((user) => user.status == params.filters!['status'])
            .toList();
      }
    }

    // Apply sorting
    if (params.orderBy != null) {
      users.sort((a, b) {
        int comparison;

        /// This is the original code that was replaced by the switch statement
        switch (params.orderBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'email':
            comparison = a.email.compareTo(b.email);
            break;
          case 'role':
            comparison = a.role.compareTo(b.role);
            break;
          case 'status':
            comparison = a.status.compareTo(b.status);
            break;
          default:
            comparison = a.id.compareTo(b.id);
        }
        return params.sortDirection == 'asc' ? comparison : -comparison;
      });
    }

    // Simulate pagination limit (return empty list after page 5)
    if (params.page >= 5) {
      return [];
    }

    return users;
  }
}
