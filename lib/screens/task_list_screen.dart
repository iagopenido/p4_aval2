import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<String> categories = ['Trabalho', 'Pessoal', 'Estudos'];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _editTask(Task task, int index) {
    setState(() {
      tasks[index] = task;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  '${task.title} - ${task.dueDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categoria: ${task.category}'),
                    Text('Descrição: ${task.description}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        showTaskDialog(
                          context: context,
                          task: task,
                          categories: categories,
                          onSave: (editedTask) {
                            _editTask(editedTask, index);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskDialog(
            context: context,
            categories: categories,
            onSave: (newTask) {
              _addTask(newTask);
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
