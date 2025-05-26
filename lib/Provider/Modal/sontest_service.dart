import 'dart:async';
import 'package:tambola/Provider/Modal/contest.dart';

class ContestService {
  // Simulating a database with a list
  final List<Contest> _contests = [];
  final _contestStreamController = StreamController<List<Contest>>.broadcast();

  Stream<List<Contest>> get contestsStream => _contestStreamController.stream;

  ContestService() {
    // Add some sample contests
    _contests.addAll([
      Contest(
        id: '1',
        title: 'Weekend Tambola',
        description: 'Join us for a fun weekend game with exciting prizes!',
        startTime: DateTime.now().add(const Duration(days: 2)),
        endTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
        isActive: true,
        participantsCount: 45,
      ),
      Contest(
        id: '2',
        title: 'Festive Special',
        description: 'Special tambola game with festive prizes and bonuses',
        startTime: DateTime.now().add(const Duration(days: 5)),
        endTime: DateTime.now().add(const Duration(days: 5, hours: 3)),
        participantsCount: 28,
      ),
      Contest(
        id: '3',
        title: 'Corporate Event',
        description: 'Exclusive tambola for corporate team building',
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        isActive: true,
        participantsCount: 120,
      ),
    ]);

    _notifyListeners();
  }

  List<Contest> getContests() {
    return List.from(_contests);
  }

  Contest? getContestById(String id) {
    try {
      return _contests.firstWhere((contest) => contest.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addContest(Contest contest) async {
    _contests.add(contest);
    _notifyListeners();
  }

  Future<void> updateContest(Contest contest) async {
    final index = _contests.indexWhere((c) => c.id == contest.id);
    if (index != -1) {
      _contests[index] = contest;
      _notifyListeners();
    }
  }

  Future<void> deleteContest(String id) async {
    _contests.removeWhere((contest) => contest.id == id);
    _notifyListeners();
  }

  Future<void> toggleContestStatus(String id) async {
    final index = _contests.indexWhere((c) => c.id == id);
    if (index != -1) {
      final contest = _contests[index];
      _contests[index] = contest.copyWith(isActive: !contest.isActive);
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    _contestStreamController.add(_contests);
  }

  void dispose() {
    _contestStreamController.close();
  }
}
