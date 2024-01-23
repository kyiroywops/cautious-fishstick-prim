import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piramjuego/infrastructure/models/carta_model.dart';
import 'package:piramjuego/infrastructure/models/player_models.dart';
import 'package:piramjuego/presentation/screens/cartafinal_screen.dart';
import 'package:piramjuego/presentation/screens/cartas_asignadas_screen.dart';
import 'package:piramjuego/presentation/screens/juego_piramide_screen.dart';
import 'package:piramjuego/presentation/screens/parametros_screen.dart';
import 'package:piramjuego/presentation/screens/resultadofinal_screen.dart';
import 'package:piramjuego/presentation/screens/seleccion_jugadores.dart';
import 'package:piramjuego/presentation/screens/inicial_home_screen.dart';
import 'package:piramjuego/presentation/screens/introductions_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
        builder: (BuildContext context, GoRouterState state) => InicialHomeScreen(),
        


    ),
    GoRoute(
      path: '/playerselection',
        builder: (BuildContext context, GoRouterState state) => PlayerSelectionScreen(),
        


    ),
     GoRoute(
      path: '/parametros',
        builder: (BuildContext context, GoRouterState state) => GamesScreen(),
      
        


    ),
     GoRoute(
      path: '/instructions',
        builder: (BuildContext context, GoRouterState state) => InstructionsScreen(),
      
        


    ),

    GoRoute(
      path: '/cartasasignadas',
      builder: (BuildContext context, GoRouterState state) => CartasAsignadasScreen(),
    ),

    GoRoute(
      path: '/juego',
      builder: (BuildContext context, GoRouterState state) => JuegoPiramideScreen(),
    ),
    GoRoute(
      path: '/cartafinal',
      builder: (BuildContext context, GoRouterState state) => FinalScreen(),
    ),
    GoRoute(
      path: '/resultadofinal',
      builder: (BuildContext context, GoRouterState state) {
        // Asegúrate de que 'extra' es un mapa con las claves 'cartaFinal' y 'jugador'
        final mapa = state.extra as Map<String, dynamic>;
        final Carta? cartaFinal = mapa['cartaFinal'] as Carta?;
        final Player? jugadorCoincidente = mapa['jugador'] as Player?;
        
        // Ahora puedes pasar estos objetos a ResultadoFinalScreen
        return ResultadoFinalScreen(cartaFinal: cartaFinal!, jugador: jugadorCoincidente);
      },
    ),




   


  ]




);
