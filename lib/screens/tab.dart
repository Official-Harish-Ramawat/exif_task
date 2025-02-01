import 'package:exif2/screens/gallery.dart';
import 'package:exif2/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:exif2/fetch_images_once.dart' as pkg;

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    Widget content = const pkg.GalleryScreen();
    if(selectedIndex == 0){
  content =const pkg.GalleryScreen();
}
if (selectedIndex==1) {
   content = const MapScreen();
}
    return Scaffold(
     
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(62, 108, 29, 122),
        selectedIconTheme: Theme.of(context).iconTheme.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
        unselectedIconTheme:Theme.of(context).iconTheme.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer
        ), 
          showUnselectedLabels: false,
          showSelectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (index){
            setState(() {
              selectedIndex = index;
            });
          } ,
          items: [
            BottomNavigationBarItem(
              label: 'Gallery',
              icon: Icon(Icons.photo_library),
            ),
            BottomNavigationBarItem(
              label: 'Google Map',
              icon: Icon(Icons.pin_drop),
            ),
          ]),
    );
  }
}
