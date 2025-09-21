import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/custom_appbar.dart';

class NotificationsView extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Notifications"),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications available.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return NotificationItem(
              title: notification.title,
              description: notification.description,
              isRead: notification.isRead,
              onTap: () {
                controller.markAsRead(index);
              },
            );
          },
        );
      }),
    );
  }
}
