import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';

class ScheduleScreen extends StatelessWidget {
  final String url;

  const ScheduleScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final decodedUrl = Uri.decodeComponent(url);
    final schedule = decodedUrl.replaceAll(' ', '%20');

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(149, 99, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: AppBarSchedule(screenWidth: screenWidth,),      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.85,
              height: screenHeight * 0.75,
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                initialScale: PhotoViewComputedScale.contained,
                imageProvider: NetworkImage(schedule,),
                backgroundDecoration: BoxDecoration(color: Theme.of(context).canvasColor)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarSchedule extends StatelessWidget {
  final double screenWidth;

  const AppBarSchedule({
    super.key,
    required this.screenWidth,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('images/icono.svg', height: 30),
          const SizedBox(width: 10),
          const Text(
            'Horario',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
