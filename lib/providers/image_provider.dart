// import 'dart:io';
// import 'package:exif/exif.dart';

// import 'package:exif2/models/image_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// Map<String, dynamic> latLng = {};
// Future getlatLng(String filename) async {
//   final fileBytes = File(filename).readAsBytesSync();
//   final data = await readExifFromBytes(fileBytes);

//   if (data.isEmpty) {
//     print("No EXIF information found");
//     latLng['lat'] = null;
//     latLng['lng'] = null;
//     return;
//   }

//   final latRef = data['GPS GPSLatitudeRef']?.toString();
//   var latVal = gpsValuesToFloat(data['GPS GPSLatitude']?.values);
//   final lngRef = data['GPS GPSLongitudeRef']?.toString();
//   var lngVal = gpsValuesToFloat(data['GPS GPSLongitude']?.values);

//   if (latRef == null || latVal == null || lngRef == null || lngVal == null) {
//     print("GPS information not found");
//     latLng['lat'] = null;
//     latLng['lng'] = null;
//     return;
//   }

//   if (latRef == 'S') {
//     latVal *= -1;
//   }

//   if (lngRef == 'W') {
//     lngVal *= -1;
//   }

//   print("lat = $latVal");
//   print("lng = $lngVal");

//   latLng['lat'] = latVal;
//   latLng['lng'] = lngVal;
// }

// double? gpsValuesToFloat(IfdValues? values) {
//   if (values == null || values is! IfdRatios) {
//     return null;
//   }

//   double sum = 0.0;
//   double unit = 1.0;

//   for (final v in values.ratios) {
//     sum += v.toDouble() * unit;
//     unit /= 60.0;
//   }

//   return sum;
// }

// class ImageNotifer extends StateNotifier<List<ImageModel>> {
//   ImageNotifer() : super([]);

//   Future<void> addImages() async {
//     final images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
//     if (images == null || images.isEmpty) return;

//     // Convert List<Future<ImageModel>> to List<ImageModel>
//     final imageModels = await Future.wait(images.map((img) async {
//       final picture = File(img.path);
//       await getlatLng(picture.path);

//       return ImageModel(
//         imagePath: picture.path,
//         latitude: latLng['lat'],
//         longitude: latLng['lng'],
//       );
//     }));

//     // Update the state with the new images
//     state = [...state, ...imageModels];
//   }
// }


// final imageProvider = StateNotifierProvider<ImageNotifer, List<ImageModel>>(
//     (ref) => ImageNotifer());

import 'dart:io';
import 'package:exif/exif.dart';
import 'package:exif2/models/image_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  Future<void> addImages() async {
    final images = await ImagePicker().pickMultiImage(requestFullMetadata: true);
    if (images == null || images.isEmpty) return;

    List<ImageModel> newImages = [];

    for (var img in images) {
      final picture = File(img.path);
      final latLng = await getLatLng(picture.path); // Fetch GPS data safely

      newImages.add(ImageModel(
        imagePath: picture.path,
        latitude: latLng['lat'],
        longitude: latLng['lng'],
      ));
    }

    state = [...state, ...newImages]; // Updating state correctly
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, List<ImageModel>>(
    (ref) => ImageNotifier());

// Function to extract GPS data safely
Future<Map<String, dynamic>> getLatLng(String filename) async {
  final fileBytes = File(filename).readAsBytesSync();
  final data = await readExifFromBytes(fileBytes);

  if (data.isEmpty) {
    print("No EXIF information found");
    return {'lat': null, 'lng':null};
  }

  final latRef = data['GPS GPSLatitudeRef']?.toString();
  var latVal = gpsValuesToFloat(data['GPS GPSLatitude']?.values);
  final lngRef = data['GPS GPSLongitudeRef']?.toString();
  var lngVal = gpsValuesToFloat(data['GPS GPSLongitude']?.values);

  if (latRef == null || latVal == null || lngRef == null || lngVal == null) {
    print('data $data');
    print("GPS information not found");
    return {'lat': null, 'lng': null};
  }

  if (latRef == 'S') latVal *= -1;
  if (lngRef == 'W') lngVal *= -1;

  return {'lat': latVal, 'lng': lngVal};
}

// Helper function to convert GPS data
double? gpsValuesToFloat(IfdValues? values) {
  if (values == null || values is! IfdRatios) {
    return null;
  }

  double sum = 0.0;
  double unit = 1.0;

  for (final v in values.ratios) {
    sum += v.toDouble() * unit;
    unit /= 60.0;
  }

  return sum;
}

