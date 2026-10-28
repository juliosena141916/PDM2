import 'package:flutter/material.dart';
import 'resultados_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  String cidadeSelecionada = 'São Paulo';
  final TextEditingController pesquisaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: cidadeSelecionada,
          items: const [
            DropdownMenuItem(value: 'São Paulo', child: Text('São Paulo')),
            DropdownMenuItem(value: 'Campinas', child: Text('Campinas')),
            DropdownMenuItem(value: 'Jundiaí', child: Text('Jundiaí')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => cidadeSelecionada = val);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: pesquisaController,
              decoration: InputDecoration(
                hintText: 'Buscar locais, endereços...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Stack(
                children: const [
                  Center(child: Text('Representação de Mapa Visual')),
                  Positioned(top: 100, left: 120, child: Icon(Icons.location_on, color: Colors.red, size: 40)),
                  Positioned(top: 200, left: 250, child: Icon(Icons.location_on, color: Colors.blue, size: 40)),
                  Positioned(top: 300, left: 180, child: Icon(Icons.location_on, color: Colors.green, size: 40)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultadosScreen(
                        cidade: cidadeSelecionada,
                        pesquisaInicial: pesquisaController.text,
                      ),
                    ),
                  );
                },
                child: const Text('Ver Resultados / Lista'),
              ),
            ),
          )
        ],
      ),
    );
  }
}