import 'package:flutter/material.dart';
import 'package:slcv/pages/LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // TextEditingController to get the entered email, username, and passwords
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Variables to track password visibility
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/main-logo-2.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              Card(
                margin: const EdgeInsets.all(23),
                shadowColor: const Color(0xFF2195F2),
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Registration',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Toggle password visibility
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        keyboardType: TextInputType.text,
                        obscureText: !isPasswordVisible,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Toggle confirm password visibility
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        keyboardType: TextInputType.text,
                        obscureText: !isConfirmPasswordVisible,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Add registration functionality here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2195F2),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
