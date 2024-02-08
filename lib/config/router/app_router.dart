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
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: InicialHomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },  
    ),
    GoRoute(
      path: '/playerselection',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: PlayerSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      },
    
    ),
     GoRoute(
      path: '/parametros',
        builder: (BuildContext context, GoRouterState state) => GamesScreen(),
      
        


    ),
    GoRoute(
      path: '/instructions',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: InstructionsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      },
    
    ),

    GoRoute(
      path: '/cartasasignadas',
      builder: (BuildContext context, GoRouterState state) => CartasAsignadasScreen(),
    ),

  GoRoute(
  path: '/juego',
  pageBuilder: (context, state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: JuegoPiramideScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Usar una curva de animación para ajustar la percepción de la velocidad
        var curve = Curves.fastOutSlowIn;

        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child,
        );
      },
    );
  },
),
    GoRoute(
      path: '/cartafinal',
      builder: (BuildContext context, GoRouterState state) => FinalScreen(),
    ),
    GoRoute(
      path: '/resultadofinal',
      builder: (BuildContext context, GoRouterState state) {
        final mapa = state.extra as Map<String, dynamic>?; // Asegúrate de que extra no es nulo
        final Carta? cartaFinal = mapa?['cartaFinal'] as Carta?;
        final List<Player> jugadoresCoincidentes = (mapa?['jugadoresCoincidentes'] as List<dynamic>?)
            ?.map((e) => e as Player)
            .toList() ?? []; // Convierte la lista dinámica en una lista de Player

        return ResultadoFinalScreen(
          cartaFinal: cartaFinal!,
          jugadoresCoincidentes: jugadoresCoincidentes,
        );

      },
    ),





   


  ]




);
