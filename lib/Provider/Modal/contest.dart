class Contest {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isActive;
  final int participantsCount;

  Contest({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.isActive = false,
    this.participantsCount = 0,
  });

  factory Contest.fromMap(Map<String, dynamic> map, String id) {
    return Contest(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startTime: map['startTime'] != null 
          ? DateTime.parse(map['startTime']) 
          : DateTime.now(),
      endTime: map['endTime'] != null 
          ? DateTime.parse(map['endTime']) 
          : DateTime.now().add(const Duration(hours: 1)),
      isActive: map['isActive'] ?? false,
      participantsCount: map['participantsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isActive': isActive,
      'participantsCount': participantsCount,
    };
  }

  Contest copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isActive,
    int? participantsCount,
  }) {
    return Contest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
      participantsCount: participantsCount ?? this.participantsCount,
    );
  }
}
