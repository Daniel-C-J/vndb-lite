import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Instantiating Uuid class to generate unique id for each VN item object.
const Uuid uuid = Uuid();

/// An alternative way to generate a unique value key other than using the built-in [UniqueKey].
ValueKey<String> uidKeyOf(String value) {
  return ValueKey<String>("$value-${uuid.v4()}");
}
