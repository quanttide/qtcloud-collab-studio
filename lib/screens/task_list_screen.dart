import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/db.dart';
import 'package:qtcloud_collab_studio/models/task.dart';

class TaskListScreen extends StatefulWidget {
  // Renamed ActionListScreen to TaskListScreen
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  TaskListScreenState createState() =>
      TaskListScreenState(); // Renamed ActionListScreenState to TaskListScreenState
}

class TaskListScreenState extends State<TaskListScreen> {
  // Renamed ActionListScreenState to TaskListScreenState
  final List<Task> _tasks =
      []; // Renamed _actions to _tasks and updated type to task_models.Task
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Renamed _loadActions to _loadTasks
  }

  // Renamed _loadActions to _loadTasks and updated method to load Task data
  void _loadTasks() async {
    final tasks =
        await DatabaseHelper().getTasks(); // Updated method to getTasks
    setState(() {
      _tasks.clear(); // Clear old data
      _tasks.addAll(tasks); // Add new data
    });
  }

  // Renamed _deleteAction to _deleteTask and updated method to delete Task
  void _deleteTask(String id) async {
    await DatabaseHelper().deleteTask(id); // Updated method to deleteTask
    _loadTasks(); // Reload data to update UI
  }

  // Updated method to build Task item
  Widget _buildTaskItem(Task task) {
    return ListTile(
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          Row(
            children: [
              Text("负责人: ${task.owner}"),
              const SizedBox(width: 16),
              Text("复核人: ${task.reviewer}"),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _deleteTask(task.id); // Updated method to _deleteTask
          setState(() {});
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
            itemCount: _tasks.length, // Updated to _tasks
            itemBuilder: (context, index) {
              return _buildTaskItem(
                  _tasks[index]); // Updated method to _buildTaskItem
            },
          ),
        ),
      ],
    );
  }

  // Updated _addTodo method to create Task
  void _addTodo(
      String title, String description, String owner, String reviewer) {
    final task = Task(
        title: title,
        description: description,
        owner: owner,
        reviewer: reviewer);
    DatabaseHelper().insertTask(task); // Updated method to insertTask
    setState(() {
      _tasks.add(task); // Updated to _tasks
    });
  }

  // Updated _showAddTodoDialog method
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        final TextEditingController ownerController = TextEditingController();
        final TextEditingController reviewerController =
            TextEditingController();

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
                controller: descriptionController,
                decoration: const InputDecoration(hintText: '输入事项描述'),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(hintText: '输入负责人'),
              ),
              TextField(
                controller: reviewerController,
                decoration: const InputDecoration(hintText: '输入复核人'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addTodo(titleController.text, descriptionController.text,
                      ownerController.text, reviewerController.text);
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
