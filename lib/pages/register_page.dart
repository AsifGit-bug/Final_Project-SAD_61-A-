import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _mobile.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered! Please login.")),
        );
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // First Name
                  TextFormField(
                    controller: _firstName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "First name required";
                      }
                      final nameRegex = RegExp(r"^[a-zA-Z]+$");
                      return nameRegex.hasMatch(v.trim())
                          ? null
                          : "Only letters, no spaces";
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(labelText: "Last Name"),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Last name required";
                      }
                      final nameRegex = RegExp(r"^[a-zA-Z]+$");
                      return nameRegex.hasMatch(v.trim())
                          ? null
                          : "Only letters, no spaces";
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mobile Number
                  TextFormField(
                    controller: _mobile,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Mobile number required";
                      }
                      final mobileRegex = RegExp(r'^01[73]\d{8}$');
                      return mobileRegex.hasMatch(v)
                          ? null
                          : "Enter a valid 11-digit number starting with 017 or 013";
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Email required";
                      }
                      final emailRegex = RegExp(
                        r"^[a-zA-Z][\w\.]*@(gmail|yahoo)\.com$",
                      );
                      return emailRegex.hasMatch(v.trim())
                          ? null
                          : "Enter a valid Gmail or Yahoo email";
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password required";
                      }
                      if (v.length < 6) {
                        return "At least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Confirm your password";
                      }
                      if (v != _password.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      child: Text(_loading ? "Please wait..." : "Register"),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Login Redirect
                  TextButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(context, '/'),
                    child: const Text("Already have an account? Login"),
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
