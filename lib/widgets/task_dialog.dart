import 'package:flutter/material.dart';
import '../models/task.dart';

void showTaskDialog({
  required BuildContext context,
  Task? task,
  required List<String> categories,
  required Function(Task) onSave,
}) {
  final titleController = TextEditingController(text: task?.title);
  final descriptionController = TextEditingController(text: task?.description);
  DateTime selectedDate = task?.dueDate ?? DateTime.now();
  String selectedCategory = task?.category ?? categories[0];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(task == null ? 'Criar Tarefa' : 'Editar Tarefa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  selectedCategory = value!;
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              TextButton(
                child: Text('Selecionar Data de Vencimento'),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    selectedDate = pickedDate;
                  }
                },
              ),
              Text('Data selecionada: ${selectedDate.toLocal()}'.split(' ')[0]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTask = Task(
                title: titleController.text,
                description: descriptionController.text,
                dueDate: selectedDate,
                category: selectedCategory,
              );
              onSave(newTask);
              Navigator.of(context).pop();
            },
            child: Text(task == null ? 'Criar' : 'Salvar'),
          ),
        ],
      );
    },
  );
}
