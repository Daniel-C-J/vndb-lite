import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GenericPost {
  const GenericPost({
    this.filters,
    this.sort,
    this.reverse,
    this.fields,
    this.results,
    this.page,
    this.user,
  });

  final List? filters;
  final String? sort;
  final bool? reverse;
  final String? fields;
  final int? results;
  final int? page;
  final String? user;

  GenericPost copyWith({
    List? filters,
    String? sort,
    bool? reverse,
    String? fields,
    int? results,
    int? page,
    String? user,
  }) {
    return GenericPost(
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      reverse: reverse ?? this.reverse,
      fields: fields ?? this.fields,
      results: results ?? this.results,
      page: page ?? this.page,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (filters != null) 'filters': filters,
      if (sort != null) 'sort': sort,
      if (reverse != null) 'reverse': reverse,
      if (fields != null) 'fields': fields,
      if (results != null) 'results': results,
      if (page != null) 'page': page,
      if (user != null) 'user': user,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'GenericPost(filters: $filters, sort: $sort, reverse: $reverse, fields: $fields, results: $results, page: $page, user: $user)';
  }

  @override
  bool operator ==(covariant GenericPost other) {
    if (identical(this, other)) return true;

    return other.filters == filters &&
        other.sort == sort &&
        other.reverse == reverse &&
        other.fields == fields &&
        other.results == results &&
        other.page == page &&
        other.user == user;
  }

  @override
  int get hashCode {
    return filters.hashCode ^
        sort.hashCode ^
        reverse.hashCode ^
        fields.hashCode ^
        results.hashCode ^
        page.hashCode ^
        user.hashCode;
  }
}
