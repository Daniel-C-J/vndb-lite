// ignore_for_file: constant_identifier_names

class APIConstants {
  static const String P1_FIELDS = "title, image.url, image.sexual, image.violence, length, rating, "
      "votecount, olang, released, description";

  static const String P2a_FIELDS = "aliases, length_minutes, devstatus, developers.name, screenshots.id, "
      "screenshots.sexual, screenshots.violence, tags.id, tags.spoiler, tags.name, tags.rating, platforms, languages";

  static const String P2b_FIELDS = "minage, languages.mtl, languages.lang";

  static const String P3_FIELDS =
      "extlinks.url, relations.id, relations.title, relations.relation, relations.relation_official, "
      "relations.image.url, relations.image.sexual, relations.image.violence, relations.length, relations.votecount, "
      "relations.olang, relations.released, relations.rating, relations.description";

  static const String USER_VNS_FIELDS = "id, vote, vn.title, added, started, finished, labels.label";
}
