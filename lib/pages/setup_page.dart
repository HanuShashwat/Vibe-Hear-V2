import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibehear/blocs/profile/profile_bloc.dart';
import 'package:vibehear/blocs/profile/profile_event.dart';
import 'package:vibehear/pages/home.dart';
import 'package:vibehear/pages/support.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController nickNameController;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    firstNameController = TextEditingController(text: profileState.firstName);
    middleNameController = TextEditingController(text: profileState.middleName);
    lastNameController = TextEditingController(text: profileState.lastName);
    nickNameController = TextEditingController(text: profileState.nickName);
  }

  void showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Missing Info"),
          content: const Text("Please enter your First Name and Last Name."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFieldSection(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: hint,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Support()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildFieldSection("First Name", firstNameController),
                      _buildFieldSection("Middle Name", middleNameController, hint: "Optional"),
                      _buildFieldSection("Last Name", lastNameController),
                      _buildFieldSection("Nick Name", nickNameController, hint: "Optional"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your data stays private. This app works 100% offline — nothing ever leaves your phone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B), // Slate 500
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    String firstName = firstNameController.text.trim();
                    String middleName = middleNameController.text.trim();
                    String lastName = lastNameController.text.trim();
                    String nickName = nickNameController.text.trim();
                    
                    if (firstName.isEmpty || lastName.isEmpty) {
                      showValidationDialog();
                    } else {
                      context.read<ProfileBloc>().add(SaveProfile(
                        firstName: firstName,
                        middleName: middleName,
                        lastName: lastName,
                        nickName: nickName,
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shadowColor: const Color(0xFF6366F1).withValues(alpha: 0.4),
                  ),
                  child: const Text('Continue to App', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
