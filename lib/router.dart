/// 页面路由

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qtcloud_collab_studio/screens/plan_list_screen.dart';

import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/memo_list_screen.dart';
import 'screens/vote_list_screen.dart';

final List<RouteBase> _routes = [
  ShellRoute(
    builder: (context, state, child) {
      String title = '量潮协作云'; // 默认标题
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: NavigationDrawer(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Text('导航菜单',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('备忘'),
              onTap: () {
                GoRouter.of(context).go('/memos');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('任务'),
              onTap: () {
                GoRouter.of(context).go('/tasks');
                Navigator.pop(context); // 关闭抽屉
              },
            ),
            ListTile(
              leading: const Icon(Icons.how_to_vote),
              title: const Text('投票'),
              onTap: () {
                GoRouter.of(context).go('/votes');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: const Text('计划'),
              onTap: () {
                GoRouter.of(context).go('/plans');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: child,
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(title: '首页'),
      ),
      GoRoute(
        path: '/memos',
        builder: (context, state) => const MemoListScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/votes',
        builder: (context, state) => const VoteListScreen(),
      ),
      GoRoute(
        path: '/plans',
        builder: (context, state) => const PlanListScreen(),
      )
    ],
  ),
];

final router = GoRouter(routes: _routes);
