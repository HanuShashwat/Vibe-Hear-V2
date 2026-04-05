import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibehear/pages/support.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade800,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Transform.translate(
          offset: Offset(-12, 0),
          child: Text(
            'About',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 6, right: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Vibe Hear:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(8, 129, 208, 1),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Vibe Hear is an offline, assistive Android application designed for completely deaf individuals. It transforms spoken words — like your name or emergency key words — into personalized vibration alerts using your phone’s in-built microphone and vibration motor. Whether someone calls you, says “Help,” or reminds you to take your medicine, the app picks up these sounds and notifies you through distinct vibration patterns you can configure yourself.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 16),

                Text(
                  "The app works entirely offline, prioritizing your privacy and ensuring fast response without needing internet access. With features like keyword-based vibration alerts, real-time speech-to-text transcription, and full user customization, Vibe Hear helps deaf users stay aware, safe, and more connected to their surroundings — anytime, anywhere.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 14),

                Divider(
                  color: Colors.grey[400],
                ),

                SizedBox(height: 14),

                Text(
                  'About the Team:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(8, 129, 208, 1),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Hanu Shashwat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://www.linkedin.com/in/hanushashwat/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/linkedin.png',
                        width: 34,
                        height: 34,
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://github.com/HanuShashwat');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/github.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Frontend Application Developer',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                    "Hanu led the development of the app’s user-facing interface using Flutter. He focused on creating a smooth and intuitive experience while implementing core features like keyword detection, vibration alerts, and offline functionality.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Tannu Sharma',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://www.linkedin.com/in/tannu-sharma-343b77331/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/linkedin.png',
                        width: 34,
                        height: 34,
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://github.com/TannuSharma861');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/github.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'UI/UX Designer',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                    "Tannu designed the app's interface and user experience, prioritizing accessibility, simplicity, and usability for deaf users. Her contribution shaped how users interact with and navigate the application.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Vivek Sharma',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://www.linkedin.com/in/vivek-sharma-18b883227/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/linkedin.png',
                        width: 34,
                        height: 34,
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://github.com/Codevek/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/github.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Backend Application Developer',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                    "Vivek was responsible for building the server-side logic and managing local data storage. His work ensured efficient keyword matching and offline data handling while maintaining app performance and privacy.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Jahanaksha Asif',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://www.linkedin.com/in/jahanaksha-asif-9743aa351/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/linkedin.png',
                        width: 34,
                        height: 34,
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://github.com/jahanaksh/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.asset(
                        'lib/images/github.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Quality Assurance & API Integration',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                    "Jahanaksha handled app testing, quality checks, and API integration. He ensured that all modules worked smoothly together and helped maintain a high standard of performance and reliability throughout development.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify
                ),

                SizedBox(height: 14),

                Divider(
                  color: Colors.grey[400],
                ),

                SizedBox(height: 14),

                Text(
                  'Terms of Service:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(8, 129, 208, 1),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'By using this application, you agree to the following terms:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "1. Purpose:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Vibe Hear is an assistive mobile application developed as a college project aimed at helping deaf and hard-of-hearing individuals by converting spoken keywords into customizable vibration alerts.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "2. Usage:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "The app is provided as-is and intended for personal, non-commercial use. Users are expected to use the application responsibly and only for its intended assistive purpose.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "3. User Content:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "All keywords and settings configured by the user are stored locally on the device. The app does not transmit or collect user data externally.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "4. Offline Operation:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Vibe Hear is designed to function fully offline. No part of the application requires or uses an internet connection.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "5. Disclaimer:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "This app is a prototype developed for educational purposes. It is not a certified medical device and should not be solely relied upon in emergency or critical situations.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "6. Modifications:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "The developers reserve the right to modify or discontinue any part of the application at any time without prior notice, especially as the app is in its prototype phase.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(height: 14),

                Divider(
                  color: Colors.grey[400],
                ),

                SizedBox(height: 14),

                Text(
                  'Privacy Policy:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(8, 129, 208, 1),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'We care deeply about your privacy. This app is designed to keep your personal data safe and secure.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "1. No Data Collection:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Vibe Hear does not collect, store, or share any personal information, audio recordings, or usage data. All operations occur locally on your device.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "2. Offline-Only Functionality:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "The app does not access the internet at any point. Keyword detection, vibration alerts, and transcript features are all processed entirely on-device.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "3. Microphone Usage:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "The app uses the device’s microphone only to detect pre-configured keywords. Audio is processed in real time and not stored or sent anywhere.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "4. Custom Settings and Keywords:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "All user defined keywords, vibration patterns, and settings are saved locally. You can clear or edit this data at any time via the app settings.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "5. No Advertisements or Trackers:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "This app does not include any form of advertising or third party tracking.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Text(
                  "6. Modifications:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "The developers reserve the right to modify or discontinue any part of the application at any time without prior notice, especially as the app is in its prototype phase.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 14),

                Divider(
                  color: Colors.grey[400],
                ),

                SizedBox(height: 14),

                Text(
                  'Contact & Feedback:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(8, 129, 208, 1),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 10),

                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: 'As a college research project, we are always looking for ways to improve. If you have suggestions, feedback, or concerns, please reach out to the development team or click ',
                        ),
                        TextSpan(
                          text: 'here',
                          style: TextStyle(
                            color: Color.fromRGBO(8, 129, 208, 1),
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Support()
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: ".",
                        )
                      ]
                  ),


                ),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

