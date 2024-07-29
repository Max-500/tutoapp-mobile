import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuto_app/config/menu-items/student/menu_items_student.dart';
import 'package:tuto_app/config/menu-items/tutor/menu_items_tutor.dart';
import 'package:tuto_app/widgets.dart';

class SideMenu extends ConsumerWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final bool isTutor;

  const SideMenu({super.key, required this.isTutor, required this.globalKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return Drawer(
      backgroundColor: const Color.fromRGBO(198, 171, 233, 1), // Color de fondo del Drawer
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, hasNotch ? 10 : 20, 20, 10),
          ),
          if(isTutor)  
            ...menuItemsTutor.map((menuItem) =>  MenuItemWidget( icon: menuItem.icon, title: menuItem.title, url: menuItem.link, globalKey: globalKey, ))
          else 
            ...menuItemsStudent.map((menuItem) => MenuItemWidget( icon: menuItem.icon, title: menuItem.title, url: menuItem.link, globalKey: globalKey)),
        ],
      ),
    );
  }
}