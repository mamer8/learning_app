import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LabProgress {
  LabProgress({
    required Set<String> openedLabIds,
    required Set<String> completedLabIds,
  }) : openedLabIds = Set.unmodifiable(openedLabIds),
       completedLabIds = Set.unmodifiable(completedLabIds);

  factory LabProgress.empty() =>
      LabProgress(openedLabIds: const {}, completedLabIds: const {});

  final Set<String> openedLabIds;
  final Set<String> completedLabIds;

  bool isOpened(String labId) =>
      openedLabIds.contains(labId) || completedLabIds.contains(labId);

  bool isCompleted(String labId) => completedLabIds.contains(labId);
}

class LabProgressService {
  static const String _storageKey = 'lab_progress_v1';

  Future<LabProgress> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedProgress = preferences.getString(_storageKey);
    if (storedProgress == null) return LabProgress.empty();
    return _decode(storedProgress);
  }

  Future<LabProgress> markOpened(String labId) async {
    final progress = await load();
    final openedLabIds = {...progress.openedLabIds, labId};
    final completedLabIds = {...progress.completedLabIds, labId};
    return _save(openedLabIds: openedLabIds, completedLabIds: completedLabIds);
  }

  Future<LabProgress> _save({
    required Set<String> openedLabIds,
    required Set<String> completedLabIds,
  }) async {
    final progress = LabProgress(
      openedLabIds: openedLabIds,
      completedLabIds: completedLabIds,
    );
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode({
        'opened': progress.openedLabIds.toList()..sort(),
        'completed': progress.completedLabIds.toList()..sort(),
      }),
    );
    if (!saved) {
      throw StateError('Failed to save lab progress.');
    }
    return progress;
  }

  LabProgress _decode(String storedProgress) {
    final decoded = jsonDecode(storedProgress);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid saved lab progress.');
    }

    return LabProgress(
      openedLabIds: _decodeIds(decoded['opened']),
      completedLabIds: _decodeIds(decoded['completed']),
    );
  }

  Set<String> _decodeIds(Object? value) {
    if (value is! List<Object?> || value.any((id) => id is! String)) {
      throw const FormatException('Invalid saved lab progress IDs.');
    }
    return value.cast<String>().toSet();
  }
}
