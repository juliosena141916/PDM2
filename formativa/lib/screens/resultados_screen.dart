import 'package:flutter/material.dart';
import '../models/local.dart';
import '../services/local_service.dart';
import '../widgets/local_card.dart';
import '../widgets/local_form.dart';
import 'detalhes_screen.dart';

class ResultadosScreen extends StatefulWidget {
  final String cidade;
  final String pesquisaInicial;

  const ResultadosScreen({
    super.key,
    required this.cidade,
    required this.pesquisaInicial,
  });

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  late TextEditingController _buscaController;
  String _categoriaFiltro = 'Todos';

  @override
  void initState() {
    super.initState();
    _buscaController = TextEditingController(text: widget.pesquisaInicial);
  }

  List<Local> filtrarLocais(
      List<Local> locais,
      String texto,
      String cidade,
      String categoria,
      ) {
    return locais.where((local) {
      final correspondeCidade =
          cidade == 'Todas' || local.cidade == cidade;
      final correspondeCategoria =
          categoria == 'Todos' || local.categoria == categoria;
      final termo = texto.toLowerCase();
      final correspondeTexto =
          local.nome.toLowerCase().contains(termo) ||
              local.categoria.toLowerCase().contains(termo);

      return correspondeCidade && correspondeCategoria && correspondeTexto;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultados (${widget.cidade})')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const LocalFormModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todos', 'Academia', 'Restaurantes', 'Hospitais']
                  .map((cat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: _categoriaFiltro == cat,
                  onSelected: (selected) {
                    setState(() => _categoriaFiltro = cat);
                  },
                ),
              ))
                  .toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Local>>(
              stream: LocalService().listarLocais(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar os dados.'));
                }

                final locaisFiltrados = filtrarLocais(
                  snapshot.data ?? [],
                  _buscaController.text,
                  widget.cidade,
                  _categoriaFiltro,
                );

                if (locaisFiltrados.isEmpty) {
                  return const Center(child: Text('Nenhum local encontrado.'));
                }

                return ListView.builder(
                  itemCount: locaisFiltrados.length,
                  itemBuilder: (context, index) {
                    final local = locaisFiltrados[index];
                    return LocalCard(
                      local: local,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalhesScreen(local: local),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}