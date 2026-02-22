import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/create_account_button.dart';
import '../../widgets/input_fields/email.dart';
import '../../widgets/input_fields/f_name.dart';
import '../../widgets/input_fields/l_name.dart';
import '../../screens/home/home_screen.dart';

class UserAccountDetailsScreen extends StatefulWidget {
  const UserAccountDetailsScreen({super.key});

  @override
  State<UserAccountDetailsScreen> createState() => _UserAccountDetailsScreenState();
}

class _UserAccountDetailsScreenState extends State<UserAccountDetailsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fill in the details to create your account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Name Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'First Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D2D3A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FirstNameInput(controller: _firstNameController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Last Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D2D3A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LastNameInput(controller: _lastNameController),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D2D3A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        EmailInput(controller: _emailController),
                        
                        const SizedBox(height: 40),
                        
                        CreateAccountButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Navigate to Home Screen with the entered name
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    userName: _firstNameController.text.isNotEmpty 
                                        ? _firstNameController.text 
                                        : "James", 
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Terms text
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By Signing up, You agree to the ',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Term of Service',
                              style: const TextStyle(color: Color(0xFF0062FF)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: const TextStyle(color: Color(0xFF0062FF)),
                               recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
      
                      const SizedBox(height: 100), // Spacer
                    ],
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
