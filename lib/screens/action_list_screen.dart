import 'package:flutter/material.dart';

class ActionListScreen extends StatefulWidget {
  const ActionListScreen({Key? key}) : super(key: key);

  @override
  ActionListScreenState createState() => ActionListScreenState();
}

class ActionListScreenState extends State<ActionListScreen> {
  final List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _todos.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '添加新的待办事项',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _todos.add(_controller.text);
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
