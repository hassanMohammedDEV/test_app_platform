class UserFilters {
  final String? search;
  final String? gender;

  const UserFilters({
    this.search,
    this.gender,
  });

  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};

    if (search != null && search!.isNotEmpty) {
      map['q'] = search;
    }
    if (gender != null) {
      map['gender'] = gender;
    }

    return map;
  }
}
