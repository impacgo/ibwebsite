import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ironingboy/Screens/bottomnavigationbar.dart';
import 'package:ironingboy/Screens/signuppage.dart';
import 'package:ironingboy/Screens/spinner.dart';
import 'package:ironingboy/bussinesslogic/loginscreen.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  State<Loginpage> createState() => _LoginpageState();
}
class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final Loginscreen _authService = Loginscreen();
  bool _isLoading = false;
  bool _showPasswordField = false;
  final List<Map<String, String>> wallpaper = [
    {'image': 'assets/images/wallpaper111.png'},
    {'image': 'assets/images/wallpaper222.png'},
    {'image': 'assets/images/wallpaper333.png'},
    {'image': 'assets/images/wallpaper444.png'},
  ];
  int _current = 0;
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }
  @override
void dispose() {
  _passwordFocusNode.dispose();
  _identifierController.dispose();
  _passwordController.dispose();
  super.dispose();
}
  Future<void> _checkUserExists() async {
if (!_formKey.currentState!.validate()) {
   debugPrint("Form validation failed");
    return;
  }
    setState(() => _isLoading = true);
    final identifier = _identifierController.text.trim();
    final result = await _authService.checkUserExists(identifier,);
    setState(() => _isLoading = false);
    if (result['exists'] == true) {
      setState(() => _showPasswordField = true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignupPage(
            prefillType: result['type'],
            prefillValue: identifier,
          ),
        ),
      );
      _showError("Account not found. Please sign up.");
    }
  }
  Future<void> _handleLogin() async {
    if (_passwordController.text.isEmpty) {
      _showError("Please enter your password");
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingScreen()));
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();
    final result = await _authService.loginWithIdentifier(identifier, password);
    Navigator.pop(context);
    if (result['success'] == true) {   
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      _showError(result['message'] ?? "Login failed");
    }
  }
  Future<void> _handleGoogleLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingScreen()));
    final result = await _authService.signInWithGoogle();
    Navigator.pop(context);

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      _showError(result['message']);
    }
  }
  String? _validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email or phone';
    }
    final input = value.trim();
    final isEmail = RegExp(
         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
        r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
      ).hasMatch(input);

    final isPhone = RegExp(r'(\d+)').hasMatch(input);
    if (!isEmail && !isPhone) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            Expanded(
            flex: 1,
            child: CarouselSlider(
              options: CarouselOptions(
                height: double.infinity,
                autoPlay: true,
                viewportFraction: 1.0,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, _) {
                  setState(() => _current = index);
                },
              ),
              items: wallpaper.map((item) {
                return Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              }).toList(),
            ),
          ),

        
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle( fontFamily: 'Poppins',
                           fontWeight: FontWeight.w700,
                                fontSize: 24,
                               
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _identifierController,
                        validator: _validateIdentifier,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Number / Email',
                          hintStyle: TextStyle( fontFamily: 'Poppins',
                           fontWeight: FontWeight.normal,
                                fontSize: 12,
                               ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                     onFieldSubmitted: (_) {
                      _checkUserExists();  
                          FocusScope.of(context).requestFocus(_passwordFocusNode); 
                    },
                      ),

                      if (_showPasswordField) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            hintStyle: TextStyle( fontFamily: 'Poppins',
                           fontWeight: FontWeight.normal,
                                fontSize: 12,
                               ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            )
                          : InkWell(
                              onTap: _showPasswordField
                                  ? _handleLogin
                                  : _checkUserExists,
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _showPasswordField ? "Login" : "Next",
                                    style: TextStyle( fontFamily: 'Poppins',
                           fontWeight: FontWeight.bold,
                           
                                fontSize: 18,
                                color: Colors.white,
                               ),
                                  ),
                                ),
                              ),
                            ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              " Or Continue With ",
                              style: TextStyle( 
                                fontFamily: 'Poppins',
                                fontSize: 12,
                               ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        children: [
                          InkWell(
                            onTap: _handleGoogleLogin,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(
                                    'assets/images/google1.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(
                                    'assets/images/Apple.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

