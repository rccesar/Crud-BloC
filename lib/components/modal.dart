import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ModalAdd extends StatefulWidget {
  final Map? tarefa;
  final int? index;

  const ModalAdd({super.key, this.tarefa, this.index});

  @override
  State<ModalAdd> createState() => _ModalAddState();
}

class _ModalAddState extends State<ModalAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _titleController.text = widget.tarefa!['titulo'] ?? '';
      _descriptionController.text = widget.tarefa!['descricao'] ?? '';
      final dataString = widget.tarefa!['dataHora'];
      if (dataString != null) {
        _selectedDateTime = DateTime.parse(dataString);
      }
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (!mounted) return;

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

  Future<void> _saveOrUpdate() async {
    final box = await Hive.openBox('tarefas');
    final tarefaData = {
      'titulo': _titleController.text,
      'descricao': _descriptionController.text,
      'dataHora': _selectedDateTime?.toIso8601String(),
    };
    if (widget.index != null) {
      // Editando
      await box.putAt(widget.index!, tarefaData);
    } else {
      // Adicionando
      await box.add(tarefaData);
    }
    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.tarefa != null ? 'Editar Tarefa' : 'Adicione Sua Tarefa',
      ),
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
          onPressed: _saveOrUpdate,
          child: Text(widget.tarefa != null ? 'Atualizar' : 'Salvar'),
        ),
      ],
    );
  }
}
