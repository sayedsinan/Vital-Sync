import 'package:health/health.dart';

class HealthService {
  final Health _health = Health(); 

 
  Future<bool> isAvailable() async {
    return await _health.isDataTypeAvailable(HealthDataType.STEPS);
  }

  Future<bool> requestPermissions() async {
    final types = <HealthDataType>[
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    return await _health.requestAuthorization(types, permissions: permissions);
  }

Future<bool?> hasPermissions() async {
    final types = <HealthDataType>[
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
    ];

    return await _health.hasPermissions(types, permissions: types.map((e) => HealthDataAccess.READ).toList());
  }
  Future<void> revokePermissions() async {
    await _health.revokePermissions();
  }

  Future<void>getSteps() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: yesterday,
      endTime: now,
    );

    if (data.isNotEmpty) {
      print('Steps in last 24 hours: ${data.last.value}');
    } else {
      print('No step data available');
    }
  }

  Future<int> fetchStepsLast24h() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: yesterday,
      endTime: now,
    );

    if (data.isNotEmpty) {
      return (data.last.value is int) ? data.last.value as int : (data.last.value is double ? (data.last.value as double).round() : 0);
    }
    return 0;
  }
}
