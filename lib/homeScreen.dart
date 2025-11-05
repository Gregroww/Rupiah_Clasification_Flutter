import 'package:flutter/material.dart';
import 'package:money_clasification/getStartupScreen.dart';
import 'scanScreen.dart';
import 'historyScreen.dart';
import 'history_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF17B3AA), Color(0xFF071427)],
    );

    final hasHistory = HistoryService.images.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header / hero
              Expanded(
                flex: hasHistory ? 7 : 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Two coin images across top
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _coinImage(),
                          const SizedBox(width: 36),
                          _coinImage(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Scan Your\nMoney',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          height: 0.95,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Article/preview area (conditional drawer)
              if (hasHistory)
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F1F3),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                    ),
                    child: Column(
                      children: [
                        // small header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Article', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('View All', style: TextStyle(color: Colors.black45)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // simple placeholder grid (two items per row)
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                            children: List.generate(4, (index) => _articleCard()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A1628)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home button
                IconButton(
                  tooltip: 'Beranda',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GetStartedScreen()),
                    );
                  },
                  icon: const Icon(Icons.home, color: Color(0xFF4ECDC4), size: 30),
                ),

                // Center scan button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen()));
                  },
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF4ECDC4), width: 4),
                    ),
                    child: const Center(child: Icon(Icons.qr_code_scanner, color: Color(0xFF0A1628), size: 34)),
                  ),
                ),

                // History button (was Gallery)
                IconButton(
                  tooltip: 'History',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                  },
                  icon: const Icon(Icons.history, color: Color(0xFF4ECDC4), size: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _coinImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, spreadRadius: 2)],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/coin.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _articleCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(color: Colors.grey[200])),
          ),
          const SizedBox(height: 8),
          const Align(alignment: Alignment.centerLeft, child: Text('100 Rupiah Coin', style: TextStyle(fontWeight: FontWeight.bold))),
          const Align(alignment: Alignment.centerLeft, child: Text('1978', style: TextStyle(color: Colors.black45, fontSize: 12))),
        ],
      ),
    );
  }
}