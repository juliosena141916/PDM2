import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
    ),
  );
}

class Aluno {
  final String nome;
  final String idade;
  final String curso;

  Aluno({required this.nome, required this.idade, required this.curso});
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // 1. Controllers dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController cursoController = TextEditingController();

  // 2. Lista local do tipo Aluno (Corrigido)
  final List<Aluno> listaAlunos = [];

  void cadastrarAluno() {
    String nome = nomeController.text.trim();
    String idade = idadeController.text.trim();
    String curso = cursoController.text.trim();

    // Verificar se os campos estão preenchidos
    if (nome.isEmpty || idade.isEmpty || curso.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Adicionar à lista e atualizar a interface
    setState(() {
      listaAlunos.add(
        Aluno(
          nome: nome,
          idade: idade,
          curso: curso,
        ),
      );
    });

    // Limpar os campos
    nomeController.clear();
    idadeController.clear();
    cursoController.clear();

    // Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aluno cadastrado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    cursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Idade'),
            ),
            TextField(
              controller: cursoController,
              decoration: const InputDecoration(labelText: 'Curso'),
            ),
            const SizedBox(height: 15),
            
            ElevatedButton(
              onPressed: cadastrarAluno, 
              child: const Text('CADASTRAR'),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: listaAlunos.length,
                itemBuilder: (context, index) {
                  final aluno = listaAlunos[index];
                  return ListTile(
                    title: Text(aluno.nome),
                    subtitle: Text('${aluno.idade} anos - ${aluno.curso}'),
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