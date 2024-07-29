import 'package:flutter/material.dart';

class MenuItemsStudent {
  final String title;
  final String link;
  final IconData icon;

  const MenuItemsStudent({required this.title, required this.link, required this.icon});
}

const menuItemsStudent = <MenuItemsStudent> [
    MenuItemsStudent(title: 'Visualizar Horario', link: '/schedule/', icon: Icons.calendar_month_outlined),
    MenuItemsStudent(title: 'Editar Perfil', link: '/update-student-data/', icon: Icons.edit_outlined),
    MenuItemsStudent(title: 'Cerrar Sesión', link: '', icon: Icons.login_outlined),
];