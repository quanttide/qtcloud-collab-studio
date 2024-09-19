/// 页面路由

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/action_list_screen.dart';


final List<RouteBase> _routes = [
  ShellRoute(
    builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('量潮协作云')),
        drawer: NavigationDrawer(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Text('导航菜单', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('首页'),
              onTap: () {
                GoRouter.of(context).go('/');
                Navigator.pop(context); // 关闭抽屉
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('待办'),
              onTap: () {
                GoRouter.of(context).go('/actions');
                Navigator.pop(context); // 关闭抽屉
              },
            ),
            const ListTile(
              leading: Icon(Icons.school),
              title: Text('笔记'),
            ),
          ],
        ),
        body: child,
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(title: "首页"),
      ),
      GoRoute(
        path: '/actions',
        builder: (context, state) => const ActionListScreen(),
      )
    ],
  ),
];

final router = GoRouter(routes: _routes);
