// ignore_for_file: public_member_api_docs, sort_constructors_first

class VnSelection {
  VnSelection({
    required this.status,
    required this.added,
    required this.vote,
    this.started,
    this.finished,
  });

 final String status;
 final DateTime? started;
 final DateTime? finished;
 final DateTime added;
 final int vote;

  VnSelection copyWith({
    DateTime? started,
    DateTime? finished,
    DateTime? added,
    String? status,
    int? vote,
  }) {
    return VnSelection(
      started: started ?? this.started,
      finished: finished ?? this.finished,
      added: added ?? this.added,
      status: status ?? this.status,
      vote: vote ?? this.vote,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'started': started?.millisecondsSinceEpoch,
      'finished': finished?.millisecondsSinceEpoch,
      'added': added.millisecondsSinceEpoch,
      'status': status,
      'vote': vote,
    };
  }

  @override
  String toString() {
    return 'VnSelection(started: $started, finished: $finished, status: $status, vote: $vote)';
  }

  @override
  bool operator ==(covariant VnSelection other) {
    if (identical(this, other)) return true;

    return other.started == started &&
        other.finished == finished &&
        other.added == added &&
        other.status == status &&
        other.vote == vote;
  }

  @override
  int get hashCode {
    return started.hashCode ^ finished.hashCode ^ added.hashCode ^ status.hashCode ^ vote.hashCode;
  }
}
