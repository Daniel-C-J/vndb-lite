// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserIdentity {
  const UserIdentity({
    required this.username,
    required this.id,
    required this.authToken,
  });
  final String username;
  final String id;
  final String authToken;

  UserIdentity copyWith({
    String? username,
    String? id,
    String? authToken,
  }) {
    return UserIdentity(
      username: username ?? this.username,
      id: id ?? this.id,
      authToken: authToken ?? this.authToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'id': id,
      'authToken': authToken,
    };
  }

  factory UserIdentity.fromMap(Map<String, dynamic> map) {
    return UserIdentity(
      username: map['username'] as String,
      id: map['id'] as String,
      authToken: map['authToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserIdentity.fromJson(String source) =>
      UserIdentity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserIdentity(username: $username, id: $id, authToken: $authToken)';

  @override
  bool operator ==(covariant UserIdentity other) {
    if (identical(this, other)) return true;

    return other.username == username && other.id == id && other.authToken == authToken;
  }

  @override
  int get hashCode => username.hashCode ^ id.hashCode ^ authToken.hashCode;
}
