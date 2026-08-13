import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import '../models/infographic.dart';

class FullScreenViewer extends StatefulWidget {
  final Infographic infographic;

  const FullScreenViewer({super.key, required this.infographic});

  @override
  State<FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    setState(() => _isDownloading = true);

    try {
      if (widget.infographic.imageUrl.startsWith('http')) {
        // Handle Permissions
        bool hasPermission = false;
        if (Platform.isAndroid) {
          // On Android 10+ (API 29+), WRITE_EXTERNAL_STORAGE is not needed for MediaStore
          // But Gal handles the internal logic. We check for basic access.
          hasPermission = await Gal.hasAccess();
          if (!hasPermission) {
            hasPermission = await Gal.requestAccess();
          }
        } else {
          hasPermission = true; // Handle other platforms
        }

        if (!hasPermission) {
          _showSnackBar("Permission denied. Cannot save image.");
          return;
        }

        // 1. Download to temporary directory
        final tempDir = await getTemporaryDirectory();
        final uri = Uri.parse(widget.infographic.imageUrl);
        final extension = uri.pathSegments.last.contains('.') 
            ? uri.pathSegments.last.split('.').last 
            : 'png';
        final tempPath = "${tempDir.path}/infographica_${DateTime.now().millisecondsSinceEpoch}.$extension";

        await Dio().download(widget.infographic.imageUrl, tempPath);

        // 2. Save to Gallery using Gal
        await Gal.putImage(tempPath);
        
        _showSnackBar("Image saved to gallery successfully!");
      } else {
        _showSnackBar("Local assets are already on your device.");
      }
    } catch (e) {
      _showSnackBar("Download failed: $e");
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _shareImage() async {
    try {
      if (widget.infographic.imageUrl.startsWith('http')) {
        final tempDir = await getTemporaryDirectory();
        final extension = widget.infographic.imageUrl.split('.').last.split('?').first;
        final tempPath = "${tempDir.path}/share_infographic.$extension";

        await Dio().download(widget.infographic.imageUrl, tempPath);
        
        await Share.shareXFiles([XFile(tempPath)], text: widget.infographic.title);
      } else {
        _showSnackBar("Sharing local assets coming soon.");
      }
    } catch (e) {
      _showSnackBar("Share failed: $e");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isDownloading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
            )
          else
            IconButton(
              icon: const Icon(Icons.download_rounded, color: Colors.white),
              tooltip: "Download original",
              onPressed: _downloadImage,
            ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            tooltip: "Share",
            onPressed: _shareImage,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: PhotoView(
        imageProvider: widget.infographic.imageUrl.startsWith('http')
            ? CachedNetworkImageProvider(widget.infographic.imageUrl)
            : AssetImage(widget.infographic.imageUrl) as ImageProvider,
        heroAttributes: PhotoViewHeroAttributes(tag: widget.infographic.id),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 5.0,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
