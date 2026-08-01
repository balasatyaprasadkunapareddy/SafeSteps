import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/app_data.dart';
import '../models/user_profile.dart';

/// DatabaseService is a singleton that wraps all Firebase Firestore operations.
/// It gracefully falls back to local data if Firebase is unavailable.
class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  bool _firebaseAvailable = false;
  UserProfile _localProfile = UserProfile.empty();

  /// Call once during app init after Firebase.initializeApp()
  void initialize({bool firebaseReady = false}) {
    _firebaseAvailable = firebaseReady;
    // Pre-unlock the "First Step" badge for every new user
    if (!_localProfile.earnedBadges.contains('b1')) {
      _localProfile = _localProfile.copyWith(
        earnedBadges: [..._localProfile.earnedBadges, 'b1'],
        xp: _localProfile.xp + 10,
        lastUpdated: DateTime.now(),
      );
    }
  }

  // ── Local In-Memory Profile ───────────────────────────────────────────

  UserProfile get localProfile => _localProfile;

  /// Update the in-memory profile (used when Firebase is not available).
  void updateLocalProfile(UserProfile updated) {
    _localProfile = updated;
  }

  // ── Save User Progress ────────────────────────────────────────────────

  /// Persist user progress to Firestore (falls back silently if unavailable).
  Future<void> saveUserProgress(UserProfile profile) async {
    _localProfile = profile;
    if (!_firebaseAvailable) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(profile.id)
          .set(profile.toMap(), SetOptions(merge: true));
      debugPrint('[DB] User progress saved: ${profile.id}');
    } catch (e) {
      debugPrint('[DB] saveUserProgress error: $e');
    }
  }

  /// Record quiz result, update score, check for badge unlocks.
  Future<UserProfile> recordQuizResult({
    required int score,
    required int totalQuestions,
  }) async {
    final percentage = (score / totalQuestions * 100).round();
    final xpGained = score * 10;

    List<String> newBadges = List.from(_localProfile.earnedBadges);

    // Badge: Quiz Starter (complete any quiz)
    if (!newBadges.contains('b3')) {
      newBadges.add('b3');
    }
    // Badge: Safety Scholar (70%+)
    if (percentage >= 70 && !newBadges.contains('b4')) {
      newBadges.add('b4');
    }
    // Badge: Traffic Expert (90%+)
    if (percentage >= 90 && !newBadges.contains('b5')) {
      newBadges.add('b5');
    }
    // Badge: Champion (all modules + 90%+)
    if (percentage >= 90 &&
        _localProfile.completedModules.length >= 4 &&
        !newBadges.contains('b6')) {
      newBadges.add('b6');
    }

    final newTotalXp = _localProfile.xp + xpGained;
    final newLevel = (newTotalXp ~/ 100) + 1;
    final newHighest = percentage > _localProfile.highestScore
        ? percentage
        : _localProfile.highestScore;

    final updated = _localProfile.copyWith(
      totalScore: _localProfile.totalScore + score,
      quizzesTaken: _localProfile.quizzesTaken + 1,
      highestScore: newHighest,
      earnedBadges: newBadges,
      xp: newTotalXp,
      level: newLevel.clamp(1, 6),
      lastUpdated: DateTime.now(),
    );

    await saveUserProgress(updated);
    return updated;
  }

  /// Mark a lesson module as completed and update profile accordingly.
  Future<UserProfile> markModuleComplete(String moduleId) async {
    if (_localProfile.completedModules.contains(moduleId)) {
      return _localProfile;
    }

    List<String> newModules = [..._localProfile.completedModules, moduleId];
    List<String> newBadges = List.from(_localProfile.earnedBadges);

    // Badge: Knowledge Seeker (first module)
    if (!newBadges.contains('b2')) {
      newBadges.add('b2');
    }

    final updated = _localProfile.copyWith(
      completedModules: newModules,
      earnedBadges: newBadges,
      xp: _localProfile.xp + 25,
      lastUpdated: DateTime.now(),
    );

    await saveUserProgress(updated);
    return updated;
  }

  // ── Firestore Streams ─────────────────────────────────────────────────

  /// Stream of survey insights. Falls back to local data if Firebase is off.
  Stream<List<Map<String, dynamic>>> getSurveyInsightStream() {
    if (!_firebaseAvailable) {
      return Stream.value(AppData.surveyInsights
          .map((s) => {
                'stat': s.stat,
                'message': s.message,
                'category': s.category,
              })
          .toList());
    }

    return FirebaseFirestore.instance
        .collection('survey_insights')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList())
        .handleError((Object e) {
      debugPrint('[DB] getSurveyInsightStream error: $e');
      return AppData.surveyInsights
          .map((s) => {
                'stat': s.stat,
                'message': s.message,
                'category': s.category,
              })
          .toList();
    });
  }

  /// Stream of leaderboard entries ordered by score.
  Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
    if (!_firebaseAvailable) {
      return Stream.value(AppData.localLeaderboard);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('highestScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => {
                  'name': d['name'] ?? 'Anonymous',
                  'score': d['highestScore'] ?? 0,
                  'level': d['level'] ?? 1,
                })
            .toList())
        .handleError((Object e) {
      debugPrint('[DB] getLeaderboardStream error: $e');
      return AppData.localLeaderboard;
    });
  }

  // ── One-Shot Queries ──────────────────────────────────────────────────

  /// Fetch the stored user profile from Firestore, or return local if unavailable.
  Future<UserProfile> getUserProfile(String userId) async {
    if (!_firebaseAvailable) return _localProfile;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        final profile = UserProfile.fromFirestore(doc);
        _localProfile = profile;
        return profile;
      }
    } catch (e) {
      debugPrint('[DB] getUserProfile error: $e');
    }
    return _localProfile;
  }
}
