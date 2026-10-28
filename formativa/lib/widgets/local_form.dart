import 'package:flutter/material.dart';
import '../models/local.dart';
import '../services/local_service.dart';

class LocalFormModal extends StatefulWidget {
  final Local? local;

  const LocalFormModal({super.key, this.local});

  @override
  State<LocalFormModal> createState() => _LocalFormModalState();
}

class _LocalFormModalState extends State<LocalFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _horarioController;
  late TextEditingController _avaliacaoController;
  late TextEditingController _distanciaController;
  late TextEditingController _descricaoController;

  String _cidadeSelecionada = 'São Paulo';
  String _categoriaSelecionada = 'Academia';

  final List<String> _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];
  final List<String> _categorias = ['Academia', 'Restaurantes', 'Hospitais'];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.local?.nome ?? '');
    _horarioController = TextEditingController(text: widget.local?.horario ?? '');
    _avaliacaoController = TextEditingController(text: widget.local?.avaliacao.toString() ?? '4.5');
    _distanciaController = TextEditingController(text: widget.local?.distancia.toString() ?? '1.0');
    _descricaoController = TextEditingController(text: widget.local?.descricao ?? '');

    if (widget.local != null) {
      if (_cidades.contains(widget.local!.cidade)) _cidadeSelecionada = widget.local!.cidade;
      if (_categorias.contains(widget.local!.categoria)) _categoriaSelecionada = widget.local!.categoria;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdicao = widget.local != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdicao ? 'Editar Local' : 'Novo Local',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do local'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _categoriaSelecionada = v!),
              ),
              DropdownButtonFormField<String>(
                value: _cidadeSelecionada,
                decoration: const InputDecoration(labelText: 'Cidade'),
                items: _cidades.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _cidadeSelecionada = v!),
              ),
              TextFormField(
                controller: _horarioController,
                decoration: const InputDecoration(labelText: 'Horário (ex: 06:00 - 22:00)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _avaliacaoController,
                      decoration: const InputDecoration(labelText: 'Avaliação (0-5)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _distanciaController,
                      decoration: const InputDecoration(labelText: 'Distância (km)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final novoLocal = Local(
                      id: widget.local?.id ?? '',
                      nome: _nomeController.text,
                      categoria: _categoriaSelecionada,
                      cidade: _cidadeSelecionada,
                      avaliacao: double.tryParse(_avaliacaoController.text) ?? 0,
                      distancia: double.tryParse(_distanciaController.text) ?? 0,
                      horario: _horarioController.text,
                      descricao: _descricaoController.text,
                      favorito: widget.local?.favorito ?? false,
                    );

                    if (isEdicao) {
                      await LocalService().atualizar(novoLocal);
                    } else {
                      await LocalService().adicionar(novoLocal);
                    }

                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Text(isEdicao ? 'Salvar Alterações' : 'Cadastrar'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}