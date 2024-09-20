import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/db.dart';
import 'package:qtcloud_collab_studio/models/action.dart' as action_models;


class ActionListScreen extends StatefulWidget {
  const ActionListScreen({Key? key}) : super(key: key);

  @override
  ActionListScreenState createState() => ActionListScreenState();
}

class ActionListScreenState extends State<ActionListScreen> {
  final List<action_models.Action> _actions = []; // 修改为存储 Action 对象的列表
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadActions(); // 新增：加载数据
  }

  // 新增：从数据库加载 Action 数据
  void _loadActions() async {
    final actions = await DatabaseHelper().getActions(); // 假设 getActions() 返回 List<Action>
    setState(() {
      _actions.clear(); // 清空旧数据
      _actions.addAll(actions); // 添加新数据
    });
  }

  // 新增：删除 Action 方法
  void _deleteAction(String id) async {
    await DatabaseHelper().deleteAction(id); // 确保 deleteAction 方法已实现
    _loadActions(); // 重新加载数据以更新 UI
  }

  // 确保 Action 类型正确
  Widget _buildActionItem(action_models.Action action) { // 修改为 action_models.Action
    return ListTile(
      title: Text(action.title), // 确保 action 有 title 属性
      subtitle: Text(action.description),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _deleteAction(action.id); // 修改：直接调用
          setState(() {}); // 强制刷新 UI
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddTodoDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _actions.length,
              itemBuilder: (context, index) {
                return _buildActionItem(_actions[index]); // ���用新方法
              },
            ),
          ),
        ],
    );
  }

  // 修改 _addTodo 方法以接受描述参数
  void _addTodo(String title, String description) {
    final action = action_models.Action(title: title, description: description);
    DatabaseHelper().insertAction(action); // 存储到数据库
    setState(() {
      _actions.add(action);
    });
  }

  // 修改 _showAddTodoDialog 方法
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController(); // 新增描述控制器
        return AlertDialog(
          title: const Text('添加待办事项'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: '输入事项标题'),
              ),
              TextField(
                controller: descriptionController, // 新增描述输入框
                decoration: const InputDecoration(hintText: '输入事项描述'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addTodo(titleController.text, descriptionController.text); // 修改为传递标题和描述
                  Navigator.of(context).pop();
                }
              },
              child: const Text('添加'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
