import 'package:flutter/material.dart';
import 'package:vital_sync/services/health_services.dart  ';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HealthService _healthService = HealthService();

  int currentSteps = 0;
  double currentHeartRate = 0.0;

  @override
  void initState() {
    super.initState();
    initHealth();
  }

  Future<void> initHealth() async {
    final available = await _healthService.isAvailable();
    if (!available) {
      debugPrint("Health data not available");
      return;
    }

    final granted = await _healthService.requestPermissions();
    if (!granted) {
      debugPrint("Permissions denied");
      return;
    }

    // Initial fetch
    final steps = await _healthService.fetchStepsLast24h();
    setState(() => currentSteps = steps);

    // Start polling for updates (simulating realtime)
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      final stepsUpdate = await _healthService.fetchStepsLast24h();
      setState(() => currentSteps = stepsUpdate);
      // heart rate can be updated similarly
      return true; // continue loop
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Steps"),
                trailing: Text(currentSteps.toString()),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Heart Rate"),
                trailing: Text(currentHeartRate.toStringAsFixed(1)),
              ),
            ),
            // TODO: add charts here
          ],
        ),
      ),
    );
  }
}
