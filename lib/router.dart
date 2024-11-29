/// 页面路由

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qtcloud_collab_studio/screens/plan_list_screen.dart';


import 'screens/home_screen.dart';
import 'screens/action_list_screen.dart';
import 'screens/note_list_screen.dart';
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
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('笔记'),
              onTap: () {
                GoRouter.of(context).go('/notes');
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: const Text('计划'),
              onTap: (){
                GoRouter.of(context).go('/plans');
                Navigator.pop(context);
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
        path: '/actions',
        builder: (context, state) => const ActionListScreen(),
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => NoteListScreen(),
      ),
      GoRoute(
        path: '/plans',
        builder: (context, state) => const PlanListScreen(),
      ),
      GoRoute(
        path: '/votes', 
        builder: (context, state) => const VoteListScreen(),
      )
    ],
  ),
];

final router = GoRouter(routes: _routes);
