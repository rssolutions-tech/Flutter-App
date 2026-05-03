import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isLoading = false;

  void showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  bool validate() {
    if (name.text.trim().length < 3) {
      showError("Name must be at least 3 characters");
      return false;
    }

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email.text.trim())) {
      showError("Enter valid email");
      return false;
    }

    if (password.text.length < 8 || password.text.length > 20) {
      showError("Password must be 8–20 characters");
      return false;
    }

    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(password.text)) {
      showError("Password must contain uppercase & number");
      return false;
    }

    if (password.text != confirmPassword.text) {
      showError("Passwords do not match");
      return false;
    }

    return true;
  }

  Future<void> register() async {
    if (!validate()) return;

    setState(() => isLoading = true);

    try {
      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.text.trim())
          .get();

      if (existingUser.docs.isNotEmpty) {
        showError("Email already registered");
        setState(() => isLoading = false);
        return;
      }

      await FirebaseFirestore.instance.collection('users').add({
        'username': name.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
        'role': 'student',
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful")),
      );

      Navigator.pop(context);

    } catch (e) {
      showError(e.toString());
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.grey.shade900]
                : [const Color(0xFF5B86E5), const Color(0xFF36D1DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12)
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(double.infinity, 50),
                          ),
                          child: const Text("Register"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}