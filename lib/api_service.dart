import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

// mock sevice 
class ApiService {
  // todo: ganti dengan endpoint api yang sebenarnya
  static const String apiUrl = '';
  
  /// kompres gambar untuk mengurangi ukuran file
  static Future<Uint8List> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) return bytes;
      
      // resize jika terlalu besar (maksimal 1024px pada sisi terpanjang)
      img.Image resized = image;
      if (image.width > 1024 || image.height > 1024) {
        if (image.width > image.height) {
          resized = img.copyResize(image, width: 1024);
        } else {
          resized = img.copyResize(image, height: 1024);
        }
      }
      
      // encode sebagai jpeg dengan pengaturan kualitas
      return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
    } catch (e) {
      return await imageFile.readAsBytes();
    }
  }
  
  /// kirim gambar ke model ai dan dapatkan prediksi
  static Future<Map<String, dynamic>> predictCoin(File imageFile) async {
    try {
      // kompres gambar terlebih dahulu
      final compressedBytes = await compressImage(imageFile);
      
      // buat multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      // tambahkan file gambar
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          compressedBytes,
          filename: 'token.jpg',
        ),
      );
      
      // kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return {
          'success': true,
          'data': jsonResponse,
        };
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  /// contoh response mock untuk testing
  static Future<Map<String, dynamic>> mockPrediction() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi network delay
    return {
      'success': true,
      'data': {
        'token_name': '100 Rupiah Coin',
        'year': '1973',
        'confidence': 0.95,
        'description': 'Uang logam (koin) Indonesia pecahan 100 rupiah tahun emisi 2010.',
      },
    };
  }
}
