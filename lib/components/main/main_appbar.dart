import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // titleSpacing: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: actions,
        bottom: bottom,
      );
}

// class LiteAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const LiteAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.bottom,
//   });

//   final String title;
//   final PreferredSizeWidget? bottom;
//   final List<Widget>? actions;

//   @override
//   Size get preferredSize =>
//       Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight * 2);

//   @override
//   Widget build(BuildContext context) => AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//         centerTitle: true,
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         // titleSpacing: 0,
//         actions: actions,
//         bottom: bottom,
//       );
// }
