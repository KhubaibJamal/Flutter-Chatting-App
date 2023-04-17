import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/text_widget.dart';
import '../Widgets/widget.dart';
import 'home_page.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});
  final String groupId;
  final String groupName;
  final String adminName;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  Constant constant = Constant();

  @override
  void initState() {
    getGroupMember();
    super.initState();
  }

  getGroupMember() async {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const TextWidget(
          title: "Group Info",
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                            const Text("Are you sure you exit the group? "),
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
                              DatabaseServices(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                      widget.groupId,
                                      constant.getName(widget.adminName),
                                      widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
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
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: constant.defaultPadding,
            vertical: constant.defaultPadding),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(constant.defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: TextWidget(
                      title: widget.groupName.substring(0, 1).toUpperCase(),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: constant.defaultPadding,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${constant.getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: members,
              builder: (context, AsyncSnapshot snapshot) {
                // make some checks
                if (snapshot.hasData) {
                  if (snapshot.data['members'] != null &&
                      snapshot.data['members'].length != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data['members'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: constant.defaultPadding / 3,
                              vertical: constant.defaultPadding / 2),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: TextWidget(
                                title: constant
                                    .getName(snapshot.data['members'][index])
                                    .substring(0, 1)
                                    .toUpperCase(),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            title: Text(constant
                                .getName(snapshot.data['members'][index])),
                            subtitle: Text(constant
                                .getId(snapshot.data['members'][index])),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("NO MEMBERS"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
