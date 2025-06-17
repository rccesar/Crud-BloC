import 'package:crudflutter/components/modal.dart' show ModalAdd;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  Box? _tarefasBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _tarefasBox = await Hive.openBox('tarefas');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_tarefasBox == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: ValueListenableBuilder(
        valueListenable: _tarefasBox!.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa adicionada'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final tarefa = box.getAt(index);
              return ListTile(title: Text(tarefa['titulo'] ?? 'Sem título'));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const ModalAdd(),
          );
          setState(() {});
        },
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
