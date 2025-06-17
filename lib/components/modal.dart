import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class ModalAdd extends StatefulWidget {
  const ModalAdd({super.key});

  @override
  State<ModalAdd> createState() => _ModalAddState();
}

class _ModalAddState extends State<ModalAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicione Suas Tarefas'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título da Tarefa'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição da Tarefa',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickDateTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data e Hora da Tarefa',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDateTime != null
                      ? '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                      : 'Selecionar data e hora',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final box = await Hive.openBox('tarefas'); // abre (ou cria) a box

            // adiciona um novo item na box com um Map com seus dados
            await box.add({
              'titulo': _titleController.text,
              'descricao': _descriptionController.text,
              'dataHora': _selectedDateTime?.toIso8601String(),
            });

            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
