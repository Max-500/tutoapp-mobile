// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String url;

  const MenuItemWidget({ super.key, required this.icon, required this.title, required this.url });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          color: const Color.fromRGBO(198, 171, 233, 1),
          child: InkWell(
            onTap: () async {
              if(url == '') {
                await SharedPreferencesServiceStudent.clearStudent();
                await SharedPreferencesServiceTutor.clearUser();
                context.go('/');
                return;
              }
              context.push(url);
            },
            splashColor: Colors.purple.withOpacity(0.3), // Color del efecto de ripple
            highlightColor: Colors.purple.withOpacity(0.4), // Color del highlight
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(title, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
