import 'package:chat_app/Widgets/widget.dart';
import 'package:flutter/material.dart';

import '../Shared/constant.dart';
import '../pages/auth/login_page.dart';
import '../pages/profile_page.dart';
import '../services/auth_services.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.userName,
    required this.email,
    required this.authServices,
    required this.isGroupSelected,
    required this.isProfileSelected,
    required this.groupOnPress,
    required this.profileOnPress,
  });

  final String userName;
  final String email;
  final AuthServices authServices;
  final bool isGroupSelected;
  final bool isProfileSelected;
  final VoidCallback groupOnPress;
  final VoidCallback profileOnPress;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: Constant().defaultPadding),
        children: [
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          SizedBox(height: Constant().defaultPadding),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: Constant().defaultPadding),
          const Divider(height: 2),
          DrawerListTile(
            title: "Groups",
            leadingIcon: Icons.group,
            onPress: groupOnPress,
            isSelected: isGroupSelected,
          ),
          DrawerListTile(
            title: "Profile",
            leadingIcon: Icons.person,
            onPress: profileOnPress,
            isSelected: isProfileSelected,
          ),
          DrawerListTile(
            title: "Logout",
            leadingIcon: Icons.logout,
            onPress: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authServices.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onPress,
    required this.isSelected,
  });
  final String title;
  final IconData leadingIcon;
  final VoidCallback onPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      selectedColor: Theme.of(context).primaryColor,
      selected: isSelected,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Constant().defaultPadding,
        vertical: Constant().defaultPadding / 2,
      ),
      leading: Icon(
        leadingIcon,
        size: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
