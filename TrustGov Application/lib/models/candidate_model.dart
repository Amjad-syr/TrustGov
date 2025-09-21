class Candidate {
  final String nationalId;
  final String name;
  final String gender;
  final int voteCount;

  Candidate({
    required this.nationalId,
    required this.name,
    required this.gender,
    this.voteCount = 0,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      nationalId: json['National_Id'].toString(),
      name: json['name'],
      gender: json['gender'] ?? "Unknown",
      voteCount: json['votes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'national_id': nationalId,
      'name': name,
      'gender': gender,
      'vote_count': voteCount,
    };
  }

  void incrementVote() {}
}
