import 'package:flutter/material.dart';

class MenuItemsTutor {
  final String title;
  final String link;
  final IconData icon;

  const MenuItemsTutor({required this.title, required this.link, required this.icon});
}

const menuItemsTutor = <MenuItemsTutor> [
  MenuItemsTutor(title: 'Tutorados', link: '/list-tutoreds', icon: Icons.people_outline ),
  MenuItemsTutor(title: 'Cerrar Sesión', link: '', icon: Icons.login_outlined),
];