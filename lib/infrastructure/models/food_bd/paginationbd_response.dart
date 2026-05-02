class Pagination {
  final int total;
  final int limit;
  final int offset;
  final int currentPage;
  final int lastPage;

  Pagination({
    required this.total,
    required this.limit,
    required this.offset,
    required this.currentPage,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    limit: json["limit"],
    offset: json["offset"],
    currentPage: json["currentPage"],
    lastPage: json["lastPage"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "offset": offset,
    "currentPage": currentPage,
    "lastPage": lastPage,
  };
}
