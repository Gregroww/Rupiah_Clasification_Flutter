import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class StartupScreen extends StatefulWidget {
  final Widget nextPage;

  const StartupScreen({super.key, required this.nextPage});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNext();
      }
    });
  }

  void _goToNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(_fadeRoute(widget.nextPage));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) =>
          FadeTransition(opacity: animation, child: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF111827)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animasi Lottie
              Lottie.asset(
                'assets/Lottie/Money.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                frameRate: FrameRate.max,
                repeat: false,
                fit: BoxFit.contain,
              ),

              // Tulisan & indikator
              Positioned(
                bottom: 60,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    Text(
                      'Coin App',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 9 / 16,
                child: Lottie.asset(
                  'assets/Lottie/Money.json',
                  controller: _controller,
                  onLoaded: (c) {
                    _controller
                      ..duration = c.duration
                      ..forward();
                  },
                  frameRate: FrameRate.max,
                  repeat: false,
                  fit: BoxFit
                      .contain, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
