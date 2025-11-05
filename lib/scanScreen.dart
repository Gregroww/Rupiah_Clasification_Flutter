import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'history_service.dart';
import 'api_service.dart';
import 'app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitializing = true;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _requestPermissionsAndInitCamera();
    } else {
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _requestPermissionsAndInitCamera() async {
    try {
      // minta izin kamera
      final cameraStatus = await Permission.camera.request();
      
      if (cameraStatus.isGranted) {
        // dapatkan daftar kamera yang tersedia
        _cameras = await availableCameras();
        
        if (_cameras.isNotEmpty) {
          await _initCamera();
        } else {
          debugPrint('No cameras available');
          setState(() => _isInitializing = false);
        }
      } else {
        debugPrint('Camera permission denied');
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint('Permission error: $e');
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _initCamera() async {
    try {
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<File?> _saveImage(String sourcePath, String prefix) async {
    try {
      if (kIsWeb) {
        // di web, langsung gunakan file (sudah bisa diakses)
        return File(sourcePath);
      }
      
      // di mobile, salin ke direktori dokumen aplikasi
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(sourcePath);
      final savedPath = path.join(appDir.path, '${prefix}_$fileName');
      return await File(sourcePath).copy(savedPath);
    } catch (e) {
      debugPrint('Save image error: $e');
      return null;
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() => _isProcessing = true);
    
    try {
      // kirim ke api ai untuk prediksi (menggunakan mock untuk saat ini)
      final result = await ApiService.mockPrediction();
      
      if (mounted) {
        setState(() => _isProcessing = false);
        
        if (result['success']) {
          // tambahkan ke riwayat dengan data prediksi
          HistoryService.addScan(imageFile.path, result['data']);
          
          // kembali ke home dengan hasil
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          _showError(result['error']);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError('Error processing image: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final XFile file = await _controller!.takePicture();
      final saved = await _saveImage(file.path, 'captured');
      
      if (saved != null) {
        await _processImage(saved);
      }
    } catch (e) {
      debugPrint('error: $e');
      _showError('Failed to capture image');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        final saved = await _saveImage(picked.path, 'picked');
        
        if (saved != null) {
          await _processImage(saved);
        }
      }
    } catch (e) {
      debugPrint('error: $e');
      _showError('Failed to pick image');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraSize = ResponsiveHelper.cameraSize(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // gradient background
          Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
          
          SafeArea(
            child: Column(
              children: [
                // header
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
                        'Scan Rupiah',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // instruksi
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 24.0 : 40.0),
                  child: Text(
                    'Arahkan kamera ke uang rupah',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.isMobile(context) ? 16 : 18,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.isMobile(context) ? 30 : 40),

                // preview kamera persegi dengan bingkai dekoratif
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // sudut dekoratif
                        SizedBox(
                          width: cameraSize + 20,
                          height: cameraSize + 20,
                          child: Stack(
                            children: [
                              // sudut kiri atas
                              Positioned(
                                top: 0,
                                left: 0,
                                child: _cornerDecoration(),
                              ),
                              // sudut kanan atas
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Transform.rotate(
                                  angle: 1.5708,
                                  child: _cornerDecoration(),
                                ),
                              ),
                              // sudut kiri bawah
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Transform.rotate(
                                  angle: -1.5708,
                                  child: _cornerDecoration(),
                                ),
                              ),
                              // sudut kanan bawah
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Transform.rotate(
                                  angle: 3.14159,
                                  child: _cornerDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // preview kamera (persegi)
                        Container(
                          width: cameraSize,
                          height: cameraSize,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: AppColors.accent, width: 3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.xl - 3),
                            child: _isInitializing
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(AppColors.accent),
                                    ),
                                  )
                                : (_controller != null && _controller!.value.isInitialized)
                                    ? FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: _controller!.value.previewSize!.height,
                                          height: _controller!.value.previewSize!.width,
                                          child: CameraPreview(_controller!),
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt, size: 60, color: Colors.white.withValues(alpha: 0.3)),
                                          const SizedBox(height: AppSpacing.lg),
                                          Text(
                                            'Kamera tidak tersedia',
                                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                                          ),
                                          const SizedBox(height: AppSpacing.sm),
                                          Text(
                                            'Silahkan gunakan galeri',
                                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.isMobile(context) ? 30 : 40),

                // kontrol
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isMobile(context) ? 40.0 : 60.0,
                    vertical: ResponsiveHelper.isMobile(context) ? 24.0 : 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // tombol galeri
                      GestureDetector(
                        onTap: _isProcessing ? null : _pickFromGallery,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.photo_library, color: Colors.white, size: 26),
                        ),
                      ),

                      // tombol capture - tanpa cahaya
                      GestureDetector(
                        onTap: _isProcessing ? null : _takePicture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accent, width: 5),
                          ),
                          child: _isProcessing
                              ? const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation(AppColors.darkBackground),
                                  ),
                                )
                              : const Icon(Icons.camera_alt, size: 38, color: AppColors.darkBackground),
                        ),
                      ),

                      // tombol info
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
                              title: const Text('Tips'),
                              content: const Text('• Pastikan uang berada di permukaan datar\n• Pastikan pencahayaan bagus\n• Tempatkan uang di tengah frame'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.info_outline, color: Colors.white, size: 26),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerDecoration() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.accent, width: 4),
          left: BorderSide(color: AppColors.accent, width: 4),
        ),
      ),
    );
  }
}
