import 'package:flutter/material.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> fakeUsers = [
      "Mohamed Hassan",
      "Ahmed Ali",
      "Sara Nabil",
      "Youssef Karim",
      "Laila Mostafa",
      "Omar Tarek",
      "Mai Ahmed",
      "Nour Mohamed",
      "Karim Yasser",
      "Hana Adel"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Users",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: fakeUsers.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(fakeUsers[index]),
              subtitle: Text("User ID: ${index + 1}"),
            ),
          );
        },
      ),
    );
  }
}