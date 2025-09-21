class Election {
  final int id;
  final String name;
  final int candidatesCount;
  final bool isActive;
  final bool hasEnded;
  final String? owner;
  final DateTime startDate;
  final DateTime endDate;

  Election({
    required this.id,
    required this.name,
    required this.candidatesCount,
    required this.isActive,
    required this.hasEnded,
    this.owner,
    required this.startDate,
    required this.endDate,
  });

  factory Election.fromJson(Map<String, dynamic> json) {
    return Election(
      id: json['id'],
      name: json['name'],
      candidatesCount: json['candidatesCount'],
      isActive: json['isActive'],
      hasEnded: json['hasEnded'],
      owner: json['owner'],
      startDate: DateTime.parse(
          json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'candidatesCount': candidatesCount,
      'isActive': isActive,
      'hasEnded': hasEnded,
      'owner': owner,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
