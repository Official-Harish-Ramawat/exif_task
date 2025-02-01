import 'dart:io';

import 'package:exif2/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() {
  return _GalleryScreenState();
  }
}

class _GalleryScreenState extends ConsumerState<GalleryScreen>{
  @override
  Widget build(BuildContext context) {

    
    final imageList = ref.watch(imageProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Gallery'),),
      body:imageList.isEmpty?Center(child: CircularProgressIndicator(),): ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (ctx, index){
        return ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Image.file(File(imageList[index].imagePath)),
            
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('Latitude : ${imageList[index].latitude} '),
             Text('longitude : ${imageList[index].longitude} '),
          ],),
        );
      } ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        await ref.read(imageProvider.notifier).addImages();
      }, child: Icon(Icons.add_a_photo),),
    );
  }
}