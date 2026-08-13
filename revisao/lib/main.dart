import 'package:flutter/material.dart';

void main() {
  runApp(const CadastroAlunosApp());
}

class CadastroAlunosApp extends StatelessWidget {
  const CadastroAlunosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Alunos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AlunosHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Aluno {
  final String nome;
  final String idade;
  final String curso;

  Aluno({required this.nome, required this.idade, required this.curso});
}

class AlunosHomePage extends StatefulWidget {
  const AlunosHomePage({super.key});

  @override
  State<AlunosHomePage> createState() => _AlunosHomePageState();
}

class _AlunosHomePageState extends State<AlunosHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cursoController = TextEditingController();

  final List<Aluno> _alunos = [];

  void _cadastrarAluno() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _alunos.add(
          Aluno(
            nome: _nomeController.text,
            idade: _idadeController.text,
            curso: _cursoController.text,
          ),
        );
      });
      
      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno cadastrado com sucesso!')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500), // Limita a largura máxima
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Formulário de Cadastro
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Novo Aluno',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Insira o nome' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _idadeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Idade',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Insira a idade' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cursoController,
                            decoration: const InputDecoration(
                              labelText: 'Curso',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Insira o curso' : null,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _cadastrarAluno,
                              child: const Text('Cadastrar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Tabela de Alunos Cadastrados
                const Text(
                  'Alunos Cadastrados',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                _alunos.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Nenhum aluno cadastrado ainda.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : Card(
                        elevation: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Idade', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Curso', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: _alunos.map((aluno) {
                              return DataRow(cells: [
                                DataCell(Text(aluno.nome)),
                                DataCell(Text(aluno.idade)),
                                DataCell(Text(aluno.curso)),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}