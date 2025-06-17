import 'package:flutter/material.dart';
import 'package:crudflutter/screens/add.dart';

void main() {
  runApp(const MainCrud());
}

class MainCrud extends StatelessWidget {
  const MainCrud({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 19, 241)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/add': (context) => const Add(), 
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Clique no Botão para iniciar'),
            const SizedBox(height: 20), // Espaço entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                // Ação ao clicar no botão
                Navigator.pushNamed(context, '/add');
              },
              child: const Text('Iniciar'),
            ),
          ],
        ),
      ),
    );
  }
}