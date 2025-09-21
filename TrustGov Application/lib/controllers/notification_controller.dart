import 'package:get/get.dart';
import 'home_controller.dart';

class NotificationItemModel {
  String title;
  String description;
  bool isRead;

  NotificationItemModel({
    required this.title,
    required this.description,
    this.isRead = false,
  });
}

class NotificationController extends GetxController {
  var notifications = <NotificationItemModel>[
    NotificationItemModel(
      title: "Election Notification",
      description: "The presidential elections have started.",
    ),
  ].obs;

  bool get hasUnreadNotifications =>
      notifications.any((notification) => !notification.isRead);

  void markAsRead(int index) {
    if (!notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh();
      Get.find<HomeController>().updateUnreadNotifications();
    }
  }

  void addNotification(NotificationItemModel notification) {
    notifications.add(notification);
    Get.find<HomeController>().updateUnreadNotifications();
  }
}
