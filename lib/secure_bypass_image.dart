import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SecureBypassImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const SecureBypassImage({
    super.key,
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
  });

  Future<Uint8List?> _loadImageBytes(String url) async {
    try {
      final ioClient = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true; // Bypass SSL ❗️

      final request = await ioClient.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == 200) {
        return await consolidateHttpClientResponseBytes(response);
      } else {
        debugPrint('Image load failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Image load exception: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _loadImageBytes(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: fit,
            ),
          );
        } else {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: borderRadius,
            ),
            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          );
        }
      },
    );
  }
}
