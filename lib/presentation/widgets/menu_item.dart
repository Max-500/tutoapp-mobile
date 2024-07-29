// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuto_app/config/shared_preferences/student/shared_preferences_service_student.dart';
import 'package:tuto_app/config/shared_preferences/tutor/shared_preferences_services_tutor.dart';
import 'package:tuto_app/features/tutor/data/models/tutored_model.dart';
import 'package:tuto_app/presentation/providers/student/student_provider.dart';
import 'package:tuto_app/presentation/providers/tutor/tutor_provider.dart';
import 'package:tuto_app/presentation/widgets/alerts.dart';

class MenuItemWidget extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String url;
  final GlobalKey<ScaffoldState> globalKey;


  const MenuItemWidget({ super.key, required this.icon, required this.title, required this.url, required this.globalKey });

    Future<List<TutoredModel>> getTutoreds(WidgetRef ref) async {
      try {
        final getTutoreds = ref.read(getTutoredsProvider);
        return await getTutoreds();
      } catch (e){
        showToast(e.toString());
        return [];
      }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

              if(url == '/schedule/') {
                final getScheduleTutor = ref.read(getSheduleTutorProvider);
                final schedule = await getScheduleTutor();
                final encodedSchedule = Uri.encodeComponent(schedule);
                context.pop();
                context.push('/schedule/$encodedSchedule');
                return;
              }

              if(url == '/update-student-data/') {
                final getProfileImage = ref.read(getProfileImageProvider);
                final profileImage = await getProfileImage();
                final uri = Uri.parse(profileImage);
                String image = uri.pathSegments.last.replaceAll(' ', '%20');
                context.pop();
                context.push('/update-student-data/$image');
                return;
              }

              if(url == '/list-tutoreds') {
                final tutoreds = await getTutoreds(ref);

                if (tutoreds.isEmpty) {
                  context.pop();
                  context.push('/list-tutoreds', extra: []);
                  return;
                }
                context.pop();
                context.push('/list-tutoreds', extra: tutoreds);
                return;
              }

              context.go(url);
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
