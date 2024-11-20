/// 投票编辑页面

import 'package:flutter/material.dart';

class VoteFormScreen extends StatelessWidget {
  const VoteFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController option_1Controller = TextEditingController();
    final TextEditingController option_2Controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建投票'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: '投票标题'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: '描述'),
            ),
            TextField(
              controller: option_1Controller,
              decoration: const InputDecoration(labelText: '选项1'),
            ),
            TextField(
              controller: option_2Controller,
              decoration: const InputDecoration(labelText: '选项2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 处理投票创建逻辑
                String title = titleController.text;
                String description = descriptionController.text;
                String option_1 = option_1Controller.text;
                String option_2 = option_2Controller.text;

                // 假设使用一个函数保存投票
                save(title, description, option_1, option_2);
                Navigator.pop(context); // 返回上一个页面
              },
              child: const Text('创建投票'),
            ),
          ],
        ),
      ),
    );
  }

  // 新增保存投票的函数
  void save(String title, String description, String option_1, String option_2) {
    // 在这里实现保存逻辑，例如保存到数据库或本地存储
  }
}
