// lib/widgets/user_list_item.dart
import 'package:flutter/material.dart';

import '../models/user.dart';

/// A widget that displays a single user item in a list.
///
/// widget designed to be used within a ListView or similar scrolling container.
/// It displays user information in a card with an avatar and status indicators.
class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.user,
    this.onTap,
    this.showRole = true,
    this.showStatus = true,
  });

  /// The user data to display
  final User user;

  /// Callback function when the item is tapped
  final VoidCallback? onTap;

  /// Whether to show the role badge
  final bool showRole;

  /// Whether to show the status indicator
  final bool showStatus;

  /// Gets the color for the role badge based on the user's role
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red.shade100;
      case 'manager':
        return Colors.orange.shade100;
      case 'user':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  /// Gets the color for the status indicator based on the user's status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar section
              Hero(
                tag: 'user-avatar-${user.id}',
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStatusColor(user.status),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Fallback for failed image load
                      // return const AssetImage('assets/default_avatar.png');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showStatus)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(user.status),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showRole) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.role.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getRoleColor(user.role)
                                            .computeLuminance() >
                                        0.5
                                    ? Colors.black87
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.status,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Action section
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example usage:
/// ```dart
/// UserListItem(
///   user: userInstance,
///   onTap: () {
///     // Handle tap
///   },
///   showRole: true,
///   showStatus: true,
/// )
/// ```
