import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final int totalScore;
  final int quizzesTaken;
  final int highestScore;
  final List<String> earnedBadges;
  final List<String> completedModules;
  final int level;
  final int xp;
  final DateTime lastUpdated;

  const UserProfile({
    required this.id,
    required this.name,
    this.totalScore = 0,
    this.quizzesTaken = 0,
    this.highestScore = 0,
    this.earnedBadges = const [],
    this.completedModules = const [],
    this.level = 1,
    this.xp = 0,
    required this.lastUpdated,
  });

  factory UserProfile.empty() {
    return UserProfile(
      id: 'local_user',
      name: 'Explorer',
      lastUpdated: DateTime.now(),
    );
  }

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      name: data['name'] as String? ?? 'Explorer',
      totalScore: data['totalScore'] as int? ?? 0,
      quizzesTaken: data['quizzesTaken'] as int? ?? 0,
      highestScore: data['highestScore'] as int? ?? 0,
      earnedBadges: List<String>.from(data['earnedBadges'] as List? ?? []),
      completedModules: List<String>.from(data['completedModules'] as List? ?? []),
      level: data['level'] as int? ?? 1,
      xp: data['xp'] as int? ?? 0,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalScore': totalScore,
      'quizzesTaken': quizzesTaken,
      'highestScore': highestScore,
      'earnedBadges': earnedBadges,
      'completedModules': completedModules,
      'level': level,
      'xp': xp,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? totalScore,
    int? quizzesTaken,
    int? highestScore,
    List<String>? earnedBadges,
    List<String>? completedModules,
    int? level,
    int? xp,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      totalScore: totalScore ?? this.totalScore,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      highestScore: highestScore ?? this.highestScore,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      completedModules: completedModules ?? this.completedModules,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// XP needed to reach the next level
  int get xpToNextLevel => level * 100;

  /// Progress (0.0 to 1.0) toward the next level
  double get levelProgress => (xp % (level * 100)) / (level * 100);

  String get levelTitle {
    switch (level) {
      case 1:
        return 'Road Rookie';
      case 2:
        return 'Safety Learner';
      case 3:
        return 'Traffic Scholar';
      case 4:
        return 'Road Expert';
      case 5:
        return 'SafeSteps Champion';
      default:
        return 'Road Legend';
    }
  }
}
