import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartupScreen extends StatefulWidget {
  final Widget nextPage; //halaman tujuan setelah animasi selesai

  const StartupScreen({super.key, required this.nextPage});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with SingleTickerProviderStateMixin { //mixin agar bisa menggunakan AnimationController(vsync),menciptakan gerakan mulus
  late final AnimationController _controller; //controller untuk kontrol durasi Lottie

  @override
  void initState() { //dipanggil saat widget diinisialisasi(sekali aja)
    super.initState(); //panggil initState superclass
    _controller = AnimationController(vsync: this); //inisialisasi controller

    //jika animasi selesai, langsung navigasi ke halaman berikutnya
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNext();
      }
    });
  }

  //navigasi dengan efek fade ke halaman tujuan
  void _goToNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(_fadeRoute(widget.nextPage));//navigasi menggantikan halaman saat ini
  }

  @override
  void dispose() {
    _controller.dispose(); //controller dibersihkan
    super.dispose();
  }

  //transisi route fade halus
  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) =>
          FadeTransition(opacity: animation, child: page),
    );
  }

  @override
  Widget build(BuildContext context) { //tampilan ui
    //hitung ukuran layar untuk responsivitas
    final size = MediaQuery.sizeOf(context);//layar saat ini
    final shortest = size.shortestSide;
    final isTablet = shortest >= 600;

    //batas ukuran Lottie agar proporsional di HP/tablet
    final animWidth = isTablet ? size.width * 0.5 : size.width * 0.8;//80% layar di HP, 50% di tablet
    final animHeight = isTablet ? size.height * 0.5 : size.height * 0.45;//45% layar di HP, 50% di tablet

    return Scaffold(//kerangka dasar halaman
      body: Container(
        //gradient background gelap
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
              //Lottie di tengah, ukurannya dibatasi agar tidak terpotong
              Center(
                child: SizedBox(
                  width: animWidth,
                  height: animHeight,
                  child: Lottie.asset(
                    'assets/Lottie/Money.json',
                    controller: _controller, //dikendalikan oleh AnimationController
                    onLoaded: (composition) {//callback saat file Lottie dimuat
                      //set durasi animasi sesuai file Lottie lalu jalankan
                      _controller
                        ..duration = composition.duration
                        ..forward();//mulai animasi
                    },
                    frameRate: FrameRate.max,
                    repeat: false, //animasi diputar sekali saja
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              //judul/tagline di bawah animasi
              Positioned(//posisi aboslut di bawah
                bottom: 60,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    Text(
                      'Rupiah Scanner',
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
            ],
          ),
        ),
      ),
    );
  }
}
