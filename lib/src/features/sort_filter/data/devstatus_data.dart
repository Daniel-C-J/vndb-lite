// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/devstatus.dart';

const Map<int, Devstatus> DEVELOPMENT_STATUS = {
  -1: Devstatus(title: 'Unknown ', color: Colors.grey),
  0: Devstatus(title: 'Finished ', color: Colors.green),
  1: Devstatus(title: 'In Development ', color: Colors.yellow),
  2: Devstatus(title: 'Cancelled ', color: Colors.red),
};
