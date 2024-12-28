import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/db.dart';
import 'package:qtcloud_collab_studio/models/vote.dart' as vote_models;

class VoteListScreen extends StatefulWidget {
  const VoteListScreen({Key? key}) : super(key: key);

  @override
  VoteListScreenState createState() => VoteListScreenState();
}

class VoteListScreenState extends State<VoteListScreen> {
  final List<vote_models.Vote> _votes = []; // 修改为存储 Vote 对象的列表
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVotes(); // 新增：加载数据
  }

  // 新增：从数据库加载 Vote 数据
  void _loadVotes() async {
    final votes =
        await DatabaseHelper().getVotes(); // 假设 getVotes() 返回 List<Vote>
    setState(() {
      _votes.clear(); // 清空旧数据
      _votes.addAll(votes); // 添加新数据
    });
  }

  // 新增：删除 Vote 方法
  void _deleteVote(String id) async {
    await DatabaseHelper().deleteVote(id); // 确保 deleteVote 方法已实现
    _loadVotes(); // 重新加载数据以更新 UI
  }

  // 确保 Vote 类型正确
  Widget _buildVoteItem(vote_models.Vote vote) {
    // 修改为 vote_models.Vote
    return ListTile(
      title: Text(vote.title), // 确保 vote 有 title 属性
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("描述: ${vote.description}"), // 显示描述
          Row(
            children: [
              Text("选项1: ${vote.option_1}"),
              const SizedBox(width: 16), // 添加间距
              Text("选项2: ${vote.option_2}"),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _deleteVote(vote.id); // 修改：直接调用
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
                onPressed: _showAddVoteDialog,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _votes.length,
            itemBuilder: (context, index) {
              return _buildVoteItem(_votes[index]); // 使用新方法
            },
          ),
        ),
      ],
    );
  }

  // 修改 _addVote 方法以接受描述参数
  void _addVote(
      String title, String description, String option_1, String option_2) {
    final vote = vote_models.Vote(
      title: title,
      description: description,
      option_1: option_1,
      option_2: option_2, // 添加描述
    );
    DatabaseHelper().insertVote(vote); // 存储到数据库
    setState(() {
      _votes.add(vote);
    });
  }

  // 修改 _showAddVoteDialog 方法
  void _showAddVoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController(); // 新增描述控制器
        final TextEditingController option_1Controller =
            TextEditingController();
        final TextEditingController option_2Controller =
            TextEditingController();

        return AlertDialog(
          title: const Text('添加投票'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: '输入投票标题'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: '输入描述'), // 新增描述输入框
              ),
              TextField(
                controller: option_1Controller,
                decoration: const InputDecoration(hintText: '输入选项1'),
              ),
              TextField(
                controller: option_2Controller,
                decoration: const InputDecoration(hintText: '输入选项2'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addVote(
                    titleController.text,
                    descriptionController.text,
                    option_1Controller.text,
                    option_2Controller.text, // 传递描述
                  );
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
