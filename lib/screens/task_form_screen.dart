/// 待办编辑页面

import 'package:flutter/material.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController ownerController = TextEditingController();
    final TextEditingController reviewerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建待办'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: '待办标题'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: '待办描述'),
            ),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(labelText: '负责人'),
            ),
            TextField(
              controller: reviewerController,
              decoration: const InputDecoration(labelText: '复核人'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 处理待办创建逻辑
                String title = titleController.text;
                String description = descriptionController.text;
                String owner = ownerController.text;
                String reviewer = reviewerController.text;

                // 假设使用一个函数保存待办
                save(title, description, owner, reviewer);
                Navigator.pop(context); // 返回上一个页面
              },
              child: const Text('创建待办'),
            ),
          ],
        ),
      ),
    );
  }

  // 新增保存待办的函数
  void save(String title, String description, String owner, String reviewer) {
    // 在这里实现保存逻辑，例如保存到数据库或本地存储
  }
}
