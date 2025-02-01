import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> images = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // Request permission and fetch images
  Future<void> fetchImages() async {
    await fetchGalleryImages(); // Fetch images if permission is granted
  }

  // Fetch all images from the gallery
  Future<void> fetchGalleryImages() async {
    setState(() => isLoading = true);

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);

    if (albums.isNotEmpty) {
      List<AssetEntity> media = await albums.first.getAssetListPaged(
          page: 0, size: 5000 // Fetching up to 5000 images (adjust as needed)
          );

      setState(() {
        images = media;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery Images")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : images.isEmpty
              ? const Center(child: Text("No images found"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<Widget>(
                      future: _buildImageWidget(images[index]),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.done
                            ? snapshot.data ?? const Icon(Icons.image)
                            : const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                ),
    );
  }

  // Convert AssetEntity to Image Widget
  Future<Widget> _buildImageWidget(AssetEntity entity) async {
    final thumbData =
        await entity.thumbnailDataWithSize(const ThumbnailSize(200, 200));
    return thumbData != null
        ? Image.memory(thumbData, fit: BoxFit.cover)
        : const Icon(Icons.broken_image);
  }
}
