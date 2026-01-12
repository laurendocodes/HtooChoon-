import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Forgot Password"),
        foregroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Text(
                "Sorry :( We're currently working on this You can contact to the developer!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 30),
              // TextField(
              //   decoration: InputDecoration(
              //     labelText: 'Email',
              //     hintText: "ngtharkyaw2520@gmail.com",
              //     hintStyle: TextStyle(color: Colors.grey),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),
              TextButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.red.shade900,
                //   padding: EdgeInsets.symmetric(vertical: 12),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                // ),
                onPressed: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Update Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
