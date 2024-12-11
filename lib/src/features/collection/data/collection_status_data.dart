// ignore_for_file: non_constant_identifier_names

import 'package:vndb_lite/src/features/collection/domain/collection_status.dart';
import 'package:flutter/material.dart';

enum CollectionStatusCode {
  playing,
  finished,
  stalled,
  dropped,
  wishlist,
  blacklist,
}

// Using .name property for sharedPreferences support. (Rearrangement)
final Map<String, CollectionStatus> COLLECTION_STATUS_DATA = {
  CollectionStatusCode.playing.name: CollectionStatus(
    id: 1,
    status: CollectionStatusCode.playing.name,
    color: Color.fromARGB(255, 0, 195, 255),
    imagePath: "assets/images/status/playing.png",
  ),
  CollectionStatusCode.finished.name: CollectionStatus(
    id: 2,
    status: CollectionStatusCode.finished.name,
    color: Color.fromARGB(255, 20, 230, 20),
    imagePath: "assets/images/status/finished.png",
  ),
  CollectionStatusCode.stalled.name: CollectionStatus(
    id: 3,
    status: CollectionStatusCode.stalled.name,
    color: Color.fromARGB(255, 250, 150, 0),
    imagePath: "assets/images/status/stalled.png",
  ),
  CollectionStatusCode.dropped.name: CollectionStatus(
    id: 4,
    status: CollectionStatusCode.dropped.name,
    color: Color.fromARGB(255, 255, 60, 50),
    imagePath: "assets/images/status/dropped.png",
  ),
  CollectionStatusCode.wishlist.name: CollectionStatus(
    id: 5,
    status: CollectionStatusCode.wishlist.name,
    color: Color.fromARGB(255, 255, 230, 0),
    imagePath: "assets/images/status/wishlist.png",
  ),
  CollectionStatusCode.blacklist.name: CollectionStatus(
    id: 6,
    status: CollectionStatusCode.blacklist.name,
    color: Color.fromARGB(255, 190, 55, 55),
    imagePath: "assets/images/status/blacklist.png",
  ),
};
