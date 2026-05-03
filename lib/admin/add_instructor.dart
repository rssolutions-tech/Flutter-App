import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddInstructorPage extends StatefulWidget {
  const AddInstructorPage({super.key});

  @override
  State<AddInstructorPage> createState() => _AddInstructorPageState();
}

class _AddInstructorPageState extends State<AddInstructorPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> addInstructor() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'username': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'role': 'instructor',
        'isActive': true,
        'createdAt': Timestamp.now(),
      });

      nameController.clear();
      emailController.clear();
      passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Instructor Added Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget customField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF4A6CF7)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 55,
                bottom: 40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Instructor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Create new instructor account",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ICON
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4A6CF7).withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 55,
                        color: Color(0xFF4A6CF7),
                      ),
                    ),

                    const SizedBox(height: 28),

                    customField(
                      hint: "Instructor Name",
                      icon: Icons.person,
                      controller: nameController,
                    ),

                    customField(
                      hint: "Email Address",
                      icon: Icons.email,
                      controller: emailController,
                    ),

                    customField(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      obscure: true,
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6CF7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading ? null : addInstructor,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Add Instructor",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
