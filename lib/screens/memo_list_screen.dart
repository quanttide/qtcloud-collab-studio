import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/models/memo.dart';
import 'package:qtcloud_collab_studio/screens/memo_form_screen.dart';
import 'package:qtcloud_collab_studio/db.dart';

class MemoListScreen extends StatefulWidget {
  const MemoListScreen({Key? key})
      : super(key: key); // Add named parameter here

  @override
  MemoListScreenState createState() => MemoListScreenState();
}

class MemoListScreenState extends State<MemoListScreen> {
  List<Memo> _memos = [];

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  void _loadMemos() async {
    final memos = await DatabaseHelper().getMemos();
    setState(() {
      _memos = memos;
    });
  }

  void _deleteMemo(int id) async {
    await DatabaseHelper().deleteMemo(id);
    _loadMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('备忘录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoFormScreen(
                    dbHelper: DatabaseHelper(),
                    onSaveComplete: _loadMemos,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _memos.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _memos[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_memos[index].content),
                Text(
                  '最后修改时间: ${_memos[index].lastModified}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (_memos[index].id != null) {
                  _deleteMemo(_memos[index].id!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
