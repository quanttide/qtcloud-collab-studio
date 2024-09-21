import 'package:flutter/material.dart';
import '../models/plan.dart';
import '../db.dart';

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({super.key});

  @override
  PlanListScreenState createState() => PlanListScreenState();
}

class PlanListScreenState extends State<PlanListScreen> {
  List<Plan> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() async {
    final plans = await DatabaseHelper().getPlans();
    setState(() {
      _plans = plans;
    });
  }

  void _deletePlan(String id) async {
    await DatabaseHelper().deletePlan(id);
    _loadPlans(); // 重新加载计划
  }

  void _addNewPlan() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加新计划'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '标题'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: '描述'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 添加新计划到数据库
                DatabaseHelper().insertPlan(Plan(
                  title: titleController.text,
                  description: descriptionController.text,
                ));
                _loadPlans(); // 重新加载计划
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计划列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addNewPlan(); // 添加新计划的逻辑
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return ListTile(
            title: Text(plan.title),
            subtitle: Text(plan.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deletePlan(plan.id);
              },
            ),
          );
        },
      ),
    );
  }
}
