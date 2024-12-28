import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/db.dart';
import 'package:qtcloud_collab_studio/models/memo.dart';

class MemoFormScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;
  final VoidCallback onSaveComplete;

  MemoFormScreen({required this.dbHelper, required this.onSaveComplete});

  @override
  _MemoFormScreenState createState() => _MemoFormScreenState();
}

class _MemoFormScreenState extends State<MemoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加备忘录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '标题'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入标题';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '内容'),
                onSaved: (value) {
                  _content = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入内容';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final memo = Memo(
                      title: _title,
                      content: _content,
                      lastModified: DateTime.now(),
                    );
                    await widget.dbHelper.insertMemo(memo);
                    widget.onSaveComplete();
                    Navigator.pop(context);
                  }
                },
                child: Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
