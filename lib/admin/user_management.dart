import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  String selectedRole = 'all';

  final List<String> roles = ['all', 'student', 'instructor'];

  Future<void> toggleUserStatus(String docId, bool currentStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'isActive': !currentStatus,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          currentStatus
              ? 'User Blocked Successfully'
              : 'User Activated Successfully',
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUsers() {
    if (selectedRole == 'all') {
      return FirebaseFirestore.instance.collection('users').snapshots();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: selectedRole)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "User Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FILTER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole,
                  isExpanded: true,
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(
                        role.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // USERS LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Users Found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data!.docs[index];

                      final data = user.data() as Map<String, dynamic>;

                      final bool isActive = data['isActive'] ?? true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(
                                0xFF4A6CF7,
                              ).withOpacity(0.15),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF4A6CF7),
                                size: 30,
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['username'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    data['email'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF4A6CF7,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Text(
                                          data['role'].toString().toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF4A6CF7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? Colors.green.withOpacity(0.15)
                                              : Colors.red.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Text(
                                          isActive ? "ACTIVE" : "BLOCKED",
                                          style: TextStyle(
                                            color: isActive
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isActive
                                    ? Colors.red
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                toggleUserStatus(user.id, isActive);
                              },
                              child: Text(
                                isActive ? "Block" : "Activate",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}