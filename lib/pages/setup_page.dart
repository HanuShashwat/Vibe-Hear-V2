import 'package:flutter/material.dart';
import 'package:vibehear/pages/home.dart';
import 'package:vibehear/pages/support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('firstName') ?? '';
      middleNameController.text = prefs.getString('middleName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      nickNameController.text = prefs.getString('nickName') ?? '';
    });
  }

  void showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Missing Information"),
          content: Text("Please enter your 'First Name' and 'Last Name'."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                  "OK",
                style: TextStyle(
                    color: Color.fromRGBO(8, 129, 208, 1)
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 250, 255, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              leading: Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade800,
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    );
                  }
              ),
              title: Transform.translate(
                offset: Offset(-14, 0),
                child: Text(
                    'Setup',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.headset_mic,
                      color: Colors.grey.shade800,
                      size: 22,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const Support()
                        ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 2),

            // White box
            Center(
              child: Container(
                width: 300,
                height: 414,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: firstNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide(
                             color: Colors.grey.shade800,
                           )
                         ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'Middle Name',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: middleNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          hintText: "Optional",
                          hintStyle: TextStyle(
                            color: Colors.grey[600]
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade800,
                              )
                          ),

                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: lastNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade800,
                              )
                          ),

                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              'Nick Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  fontSize: 16
                              ),),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: nickNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          hintText: "Optional",
                          hintStyle: TextStyle(
                              color: Colors.grey[600]
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade800,
                              )
                          ),

                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.only(left: 23, right: 23, top: 14),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                    'Your data stays private. This app works 100% offline — nothing ever leaves your phone.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            SizedBox(height: 37),

            GestureDetector(
              onTap: () async {
                String firstName = firstNameController.text.trim();
                String middleName = middleNameController.text.trim();
                String lastName = lastNameController.text.trim();
                String nickName = nickNameController.text.trim();
                if (firstName.isEmpty || lastName.isEmpty) {
                  showValidationDialog();
                } else {
                  // Saving Names Locally (So that user needn't to write it again n again)
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('firstName', firstName);
                  await prefs.setString('middleName', middleName);
                  await prefs.setString('lastName', lastName);
                  await prefs.setString('nickName', nickName);
                  await prefs.setBool('isFirstTime', false);

                  if (!context.mounted) return;

                  // Navigation to Home Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                          firstName: firstName,
                          middleName: middleName,
                          lastName: lastName,
                          nickName: nickName,
                        )
                    ),
                  );
                }
              },
              child: Center(
                child: Container(
                  width: 280,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromRGBO(8, 129, 208, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
