import 'package:flutter/material.dart';
import 'package:qtcloud_collab_studio/models/note.dart';
import 'note_form_screen.dart';  // 添加这一行


class NoteListScreen extends StatefulWidget {
  NoteListScreen({Key? key}) : super(key: key);

  final List<Note> notes = [
    Note(title: '购物清单', content: '牛奶, 面包, 鸡蛋', lastModified: DateTime.now().subtract(const Duration(days: 1))),
    Note(title: '会议记录', content: '讨论新项目进度', lastModified: DateTime.now().subtract(const Duration(hours: 3))),
    Note(title: '想法', content: '开发一个新的 App', lastModified: DateTime.now().subtract(const Duration(minutes: 30))),
  ];

  @override
  NoteListScreenState createState() => NoteListScreenState();
}

class NoteListScreenState extends State<NoteListScreen> {
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
                  builder: (context) => NoteFormScreen(
                    onSave: (title, content) {
                      setState(() {
                        widget.notes.add(Note(
                          title: title,
                          content: content,
                          lastModified: DateTime.now(),
                        ));
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: widget.notes.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget.notes[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.notes[index].content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(widget.notes[index].lastModified),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'; // 今天，显示时间
    } else if (difference.inDays < 7) {
      return _getWeekday(date.weekday); // 本周，显示星期几
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'; // 更早，显示完整日期
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return '星期一';
      case 2: return '星期二';
      case 3: return '星期三';
      case 4: return '星期四';
      case 5: return '星期五';
      case 6: return '星期六';
      case 7: return '星期日';
      default: return '';
    }
  }
}
