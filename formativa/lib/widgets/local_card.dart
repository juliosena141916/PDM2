import 'package:flutter/material.dart';
import '../models/local.dart';
import '../services/local_service.dart';
import '../dialogs/confirm_delete.dart';
import 'local_form.dart';

class LocalCard extends StatelessWidget {
  final Local local;
  final VoidCallback onTap;

  const LocalCard({super.key, required this.local, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(local.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${local.categoria} • ${local.cidade}'),
            Text('${local.distancia} km  |  ★ ${local.avaliacao}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                local.favorito ? Icons.favorite : Icons.favorite_border,
                color: local.favorito ? Colors.red : null,
              ),
              onPressed: () => LocalService().alterarFavorito(local.id, !local.favorito),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => LocalFormModal(local: local),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmou = await mostrarDialogoExclusao(context);
                if (confirmou == true) {
                  await LocalService().excluir(local.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}