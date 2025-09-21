import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_navbar.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/personal_info_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final PersonalInfoController personalInfoController =
      Get.put(PersonalInfoController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildHeader(context),
          _buildCountdown(),
          const Spacer(),
          const CustomNavBar(activePage: '/home'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications,
                      size: 30, color: Colors.white),
                  onPressed: () => Get.toNamed('/notifications'),
                ),
                Obx(() {
                  if (controller
                      .notificationController.hasUnreadNotifications) {
                    return const Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 6,
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
            const SizedBox(width: 10),
          ],
        ),
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    return Column(
      children: [
        Obx(() {
          String firstName = "User";
          if (personalInfoController.fullName.value.isNotEmpty) {
            firstName = personalInfoController.fullName.value.split(" ").first;
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome $firstName",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35444F)),
                ),
                const Icon(Icons.person, size: 30, color: Color(0xFF35444F)),
              ],
            ),
          );
        }),
        const SizedBox(height: 30),
        Obx(() {
          final electionName = controller.electionName.value;
          return Text(
            "Time left until the end of the $electionName:",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          );
        }),
        const SizedBox(height: 10),
        Obx(() {
          final time = controller.remainingTime.value;
          final isCloseToEnd = time <= const Duration(minutes: 5);
          final isEnded = time == Duration.zero;
          Color timeColor;

          if (isEnded) {
            timeColor = Colors.grey;
          } else {
            timeColor = isCloseToEnd ? Colors.red : Colors.green;
          }

          String displayTime;
          if (isEnded) {
            displayTime = "Election Ended";
          } else {
            displayTime = HomeController.formatDuration(time);
          }

          return Text(
            displayTime,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: timeColor,
            ),
          );
        }),
      ],
    );
  }
}
