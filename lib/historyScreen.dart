import 'dart:io';

import 'package:flutter/material.dart';

import 'history_service.dart';
import 'app_theme.dart';
import 'scanScreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _handleNavigation(int index) {
    if (index == 0) {
      // kembali ke home
      Navigator.pop(context);
    } else if (index == 1) {
      // ke scan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ScanScreen()),
      );
    }
    // index == 2 adalah halaman saat ini (history)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // gradient background
          Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
          
          SafeArea(
            child: Column(
              children: [
                // header (sama dengan scanScreen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'History',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // area konten
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12 : 16),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.xxl),
                        topRight: Radius.circular(AppRadius.xxl),
                      ),
                    ),
                    child: _buildList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // navigasi bawah
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildList() {
    final scans = HistoryService.scans.reversed.toList();
    if (scans.isEmpty) {
      return const Center(child: Text('Belum ada scan', style: TextStyle(color: Colors.black54)));
    }
    return ListView.separated(
      itemCount: scans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final scan = scans[index];
        return _buildCard(scan, index);
      },
    );
  }

  Widget _buildCard(ScanResult scan, int listIndex) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.file(
              File(scan.imagePath),
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.coinName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tahun: ${scan.year}',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  '${scan.scanDate.year}-${scan.scanDate.month.toString().padLeft(2, '0')}-${scan.scanDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              // hapus dari riwayat
              final origIndex = HistoryService.scans.length - 1 - listIndex;
              setState(() {
                HistoryService.removeAt(origIndex);
              });
            },
          ),
        ],
      ),
    );
  }
}
