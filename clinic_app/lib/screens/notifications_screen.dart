import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();
  List<NotificationModel> _notifs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _service.getNotifications();
      setState(() { _notifs = items; _loading = false; });
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  Future<void> _markRead(NotificationModel n) async {
    try {
      await _service.markRead(n.id);
      setState(() { _notifs = _notifs.map((x) => x.id == n.id ? NotificationModel(id: x.id, userId: x.userId, message: x.message, createdAt: x.createdAt, read: true) : x).toList(); });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _notifs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final n = _notifs[index];
          return Card(
            color: n.read ? Colors.white : Colors.blue[50],
            child: ListTile(
              title: Text(n.message),
              subtitle: Text(n.createdAt),
              trailing: n.read ? null : TextButton(onPressed: () => _markRead(n), child: const Text('Marquer lu')),
            ),
          );
        },
      ),
    );
  }
}
