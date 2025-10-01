import 'package:flutter/material.dart';

class HomeToDo extends StatefulWidget {
  const HomeToDo({super.key});

  @override
  State<HomeToDo> createState() => _HomeToDoState();
}

class _HomeToDoState extends State<HomeToDo> {
  final List<String> _tarefas = [];
  final List<bool> _tarefasConcluidas = [];

  final TextEditingController _currentTaskController = TextEditingController();

  void _adicionarTarefa() {
    if (_currentTaskController.text.trim().isNotEmpty) {
      setState(() {
        _tarefas.add(_currentTaskController.text.trim());
        _tarefasConcluidas.add(false);
      });
      _currentTaskController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
      _tarefasConcluidas.removeAt(index);
    });
  }

  Future<void> _mostrarDialogoDeConfirmacao(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
            'Você tem certeza que deseja excluir esta tarefa?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                _removerTarefa(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _currentTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("To-Do List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentTaskController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.task_alt),
                      hintText: "Digite uma tarefa...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _adicionarTarefa(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _adicionarTarefa,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tarefas.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhuma tarefa adicionada",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(
                              _tarefas[index],
                              style: TextStyle(
                                decoration: _tarefasConcluidas[index]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: _tarefasConcluidas[index]
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            leading: Checkbox(
                              value: _tarefasConcluidas[index],
                              onChanged: (novoValor) {
                                setState(() {
                                  _tarefasConcluidas[index] =
                                      novoValor ?? false;
                                });
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _mostrarDialogoDeConfirmacao(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
