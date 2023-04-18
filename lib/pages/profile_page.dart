import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';

import '../Widgets/custom_drawer.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userName, required this.email});
  final String userName;
  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const TextWidget(
          title: "Profile",
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawer: CustomDrawer(
        userName: widget.userName,
        email: widget.email,
        authServices: authServices,
        isGroupSelected: false,
        isProfileSelected: true,
        groupOnPress: () {
          nextScreen(context, const HomePage());
        },
        profileOnPress: () {},
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 140),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name:", style: TextStyle(fontSize: 17)),
                Text(widget.userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email:", style: TextStyle(fontSize: 17)),
                Text(widget.email, style: const TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
