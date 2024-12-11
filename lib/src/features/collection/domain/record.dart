// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VnRecord {
  const VnRecord({
    required this.id,
    required this.title,
    required this.status,
    required this.vote,
    this.added,
    this.started,
    this.finished,
  });

  final String id;
  final String title;
  final String status;
  final int vote;
  final String? added;
  final String? started;
  final String? finished;

  VnRecord copyWith({
    String? id,
    String? title,
    String? status,
    int? vote,
    String? added,
    String? started,
    String? finished,
  }) {
    return VnRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      vote: vote ?? this.vote,
      added: added ?? this.added,
      started: started ?? this.started,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'status': status,
      'vote': vote,
      'added': added,
      'started': started,
      'finished': finished,
    };
  }

  factory VnRecord.fromMap(Map<String, dynamic> map) {
    return VnRecord(
      id: map['id'] as String,
      title: map['title'] as String,
      status: map['status'] as String,
      vote: map['vote'] as int,
      added: map['added'] != null ? map['added'] as String : null,
      started: map['started'] != null ? map['started'] as String : null,
      finished: map['finished'] != null ? map['finished'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VnRecord.fromJson(String source) => VnRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VnRecord(id: $id, title: $title, status: $status, vote: $vote, added: $added, started: $started, finished: $finished)';
  }

  @override
  bool operator ==(covariant VnRecord other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.status == status &&
        other.vote == vote &&
        other.added == added &&
        other.started == started &&
        other.finished == finished;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        status.hashCode ^
        vote.hashCode ^
        added.hashCode ^
        started.hashCode ^
        finished.hashCode;
  }
}
