import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piramjuego/presentation/providers/baraja_provider.dart';
import 'package:piramjuego/presentation/providers/player_provider.dart'; // Importa tu playerProvider
import 'package:piramjuego/presentation/widgets/boton_atras.dart';

class CartasAsignadasScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jugadores = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cartas Asignadas a Jugadores'),
        leading: BotonAtras(),
        // Otros elementos del AppBar...
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(barajaProvider.notifier).generarYBarajarMazo();
              ref.read(barajaProvider.notifier).asignarCartas(jugadores, 2); // Asigna 2 cartas por jugador
            },
            child: Text('Generar y Asignar Cartas'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                final jugador = jugadores[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(jugador.avatar),
                  ),
                  title: Text(jugador.name),
                  subtitle: jugador.cartas.isNotEmpty
                      ? Text(jugador.cartas.map((c) => c.toString()).join(', '))
                      : Text("Sin cartas"),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}
