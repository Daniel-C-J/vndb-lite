// coverage:ignore-file

/// A small helper function to return a Future with a configurable delay.
Future<void> delay(bool addDelay, [int milliseconds = 2000]) {
  if (addDelay) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  return Future.value();
}
