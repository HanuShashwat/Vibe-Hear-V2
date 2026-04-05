import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({super.key});

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
            'Support',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 18, right: 25),
          child: Column(
            children: [
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: 'Need Help?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(8, 129, 208, 1),
                        ),
                      ),
                      TextSpan(
                        text: " You're at the Right Place.\nWe’re here to support you—every step of the way.",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Ways To Contact Us:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/images/call.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "Call - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              TextSpan(
                                  text: "Call us on 6201668873.",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/images/message.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "SMS - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              TextSpan(
                                  text: "Text us on 6201668873.",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'lib/images/gmail.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "Gmail - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              TextSpan(
                                  text: "Email us on help@vibehear.in.",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'lib/images/whatsapp.png',
                      height: 26,
                      width: 26,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "WhatsApp - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              TextSpan(
                                  text: "Message us on +91 6201668873 or click ",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  )
                              ),

                              TextSpan(
                                  text: "here",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(8, 129, 208, 1),
                                    decoration: TextDecoration.underline,
                                  ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri url = Uri.parse('https://wa.me/916201668873');
                              if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                              } else {
                              throw 'Could not launch $url';
                                //print('Could not launch $url');
                              }
                              },
                              ),
                              TextSpan(
                                  text: ".",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  )
                              ),


                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'lib/images/service.png',
                    height: 250,
                    width: 250,
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