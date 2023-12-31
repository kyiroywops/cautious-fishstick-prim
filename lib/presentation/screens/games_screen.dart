import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/infrastructure/models/game_models.dart';
import 'package:piramjuego/presentation/providers/gamemode_provider.dart';
import 'package:piramjuego/presentation/widgets/boton_atras.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesScreen extends ConsumerWidget {
  // URL de tu comunidad en Discord
  final String discordUrl = 'https://discord.gg/tuComunidad';
  

  // Método para abrir el enlace de Discord
  void _launchDiscord(BuildContext context) async {
    if (await canLaunch(discordUrl)) {
      await launch(discordUrl);
    } else {
      // Mostrar error o manejar la situación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el enlace de Discord')),
      );
    }
  }

    @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMode = ref.watch(gameModeProvider.state).state;

    

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          leading: BotonAtras(),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8), // Espacio entre el contenedor y el botón de Discord
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                gameMode == GameMode.custom ? 'Personalizada' : 'Rápida',
                style: TextStyle(color: Colors.white, fontFamily: 'Lexend'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.discord, color: Colors.white),
                onPressed: () => _launchDiscord(context),
              ),
            ),
          ],
        ),
      body: Placeholder()
    );
  }
}

