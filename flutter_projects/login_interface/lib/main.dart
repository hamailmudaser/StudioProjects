import 'package:flutter/material.dart';

// Yeh app chalane ka main point hai
void main() {
  runApp(MyApp()); // yha se app start hti h
}

// MyApp class, jo puri app ka layout aur theme define krti h
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Login', // App ka name set krta h
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme ka color set krta h
      ),
      home: LoginScreen(), // Login screen dikhata hai jb app khulti h
    );
  }
}

// Login screen bnane wli class
class LoginScreen extends StatelessWidget {
  // Yeh controllers text fields ka data store krte hain
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Yeh screen ka basic layout bnata h
      body: Center(
        // Content ko screen ke beech mein lta h
        child: SingleChildScrollView(
          // Content ko scrollable banata hai (chhoti screens ke liye)
          padding: const EdgeInsets.all(16.0), // Content ke ird-gird jga deta h
          child: Container(
            // Yeh box login form ka background banata h
            width:
                MediaQuery.of(context).size.width < 600 ? double.infinity : 400,
            // Agar screen chhoti h to full width, vrna fixed width 400
            padding: const EdgeInsets.all(20.0), // Box ke andr padding deta h
            decoration: BoxDecoration(
              color: Colors.white, // Box ka background white rakhta h
              borderRadius:
                  BorderRadius.circular(10.0), // Box ke edges gol karta h
              boxShadow: const [
                // Shadow lagata hai box ke nichy
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 5)),
              ],
            ),

            child: Column(
              // Form ke elements vertically arrange karta h
              mainAxisSize:
                  MainAxisSize.min, // Sirf content jitni height rakhta h
              children: [
                // Login ka title
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold), // Bara aur bold text
                ),
                const SizedBox(height: 20), // Title aur form ke darmiyan gap
                // Email input field
                TextField(
                  controller:
                      emailController, // Email ka data yahan save hota h
                  decoration: const InputDecoration(
                    labelText: 'Email', // Field ke andar "Email" likha hota h
                    border:
                        OutlineInputBorder(), // Border lagata hai field ke ird-gird
                  ),
                  keyboardType:
                      TextInputType.emailAddress, // Email keyboard open karta h
                ),
                const SizedBox(
                    height:
                        20), // Email field aur password field ke darmiyan gap
                // Password input field
                TextField(
                  controller:
                      passwordController, // Password ka data yha save hota h
                  decoration: const InputDecoration(
                    labelText:
                        'Password', // Field ke andar "Password" likha hota hai
                    border:
                        OutlineInputBorder(), // Border lagata hai field ke ird-gird
                  ),
                  obscureText: true, // Password ko hidden (dots) mein dikhata h
                ),
                const SizedBox(
                    height: 20), // Password field aur button ke darmiyan gap
                // Login button
                ElevatedButton(
                  onPressed: () {
                    // Jab button click kare, yeh function chalega
                    String email = emailController.text; // Email field ka text
                    String password =
                        passwordController.text; // Password field ka text
                    print(
                        'Email: $email, Password: $password'); // Console mein data print karega
                  },
                  child: const Text('Login'), // Button ke andar likha "Login"
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity,
                        50), // Button full width aur height 50 rakhta hai
                  ),
                ),

                const SizedBox(
                    height: 20), // Button aur register link ke darmiyan gap
                // Register ka link
                TextButton(
                  onPressed: () {
                    // Yha register screen par le jane ka logic aega
                  },
                  child: const Text(
                      'Don\'t have an account? Register here.'), // Link ka text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
