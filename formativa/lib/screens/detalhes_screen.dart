import 'package:flutter/material.dart';
import '../models/local.dart';
import '../services/local_service.dart';

class DetalhesScreen extends StatefulWidget {
  final Local local;

  const DetalhesScreen({super.key, required this.local});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  late bool _favorito;

  @override
  void initState() {
    super.initState();
    _favorito = widget.local.favorito;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.local.nome),
        actions: [
          IconButton(
            icon: Icon(
              _favorito ? Icons.favorite : Icons.favorite_border,
              color: _favorito ? Colors.red : null,
            ),
            onPressed: () async {
              setState(() => _favorito = !_favorito);
              await LocalService().alterarFavorito(widget.local.id, _favorito);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.local.nome, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${widget.local.categoria} • ${widget.local.cidade}', style: const TextStyle(fontSize: 16)),
            Text('Distância: ${widget.local.distancia} km | Avaliação: ★ ${widget.local.avaliacao}'),
            const SizedBox(height: 16),
            Text('Horário: ${widget.local.horario}'),
            const SizedBox(height: 16),
            const Text('Sobre:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.local.descricao),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Ver no mapa'),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}