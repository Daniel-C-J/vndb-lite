// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class OthersScreenOption {
  const OthersScreenOption({
    required this.routeName,
    required this.leading,
    required this.title,
    this.subtitle,
  });

  final String routeName;
  final IconData leading;
  final String title;
  final String? subtitle;
}
