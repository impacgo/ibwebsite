import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ironingboy/Screens/bottomnavigationbar.dart';
import 'package:ironingboy/bussinesslogic/signupscreen.dart';
class SignupPage extends StatefulWidget {
  final String? prefillType;
  final String? prefillValue;
  const SignupPage({super.key, this.prefillType, this.prefillValue});
  @override
  State<SignupPage> createState() => _SignupPageState();
}
class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
   bool _isCarouselPlaying = true;
final CarouselController _carouselController = CarouselController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  int _currentStep = 0;
  final List<Map<String, String>> wallpaper = [
    {'image': 'assets/images/wallpaper111.png'},
    {'image': 'assets/images/wallpaper222.png'},
    {'image': 'assets/images/wallpaper333.png'},
    {'image': 'assets/images/wallpaper444.png'},
  ];
  int _current = 0;
  @override
  void initState() {
    super.initState();
    if (widget.prefillType != null && widget.prefillValue != null) {
      if (widget.prefillType == 'email') {
        _emailController.text = widget.prefillValue!;
      } else if (widget.prefillType == 'mobile') {
        _phoneController.text = widget.prefillValue!;
      }
    }
  }
void _pauseCarousel() {
  if (_isCarouselPlaying) {
    setState(() {
      _isCarouselPlaying = false;
    });
  }
}
void _resumeCarousel() {
  if (!_isCarouselPlaying) {
    setState(() {
      _isCarouselPlaying = true;
    });
  }
}
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
  Future<void> _handleSignup() async {
    if (!_agreedToTerms) {
      _showError("Please agree to the Terms and Conditions.");
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await Signupscreen.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (result.success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    } else {
      FocusScope.of(context).unfocus();
      _showError(result.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _resumeCarousel();
      },
      child: Scaffold(
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
                  onPageChanged: (index, _) => setState(() => _current = index),
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
                          "Signup",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_currentStep == 0) ...[
                          _buildTextField(_nameController, "Full Name", Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneController, "Phone Number", Icons.phone,
                              keyboard: TextInputType.phone),
                          const SizedBox(height: 16),
                          _buildTextField(_emailController, "Email", Icons.email,
                              keyboard: TextInputType.emailAddress),
                          const SizedBox(height: 25),
                          _buildGradientButton("Next", () {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _currentStep = 1);
                            }
                          }),
                        ],
                        if (_currentStep == 1) ...[
                          _buildPasswordField(_passwordController, "Password"),
                          const SizedBox(height: 16),
                          _buildPasswordField(_confirmPasswordController, "Confirm Password", confirm: true),
                          const SizedBox(height: 16),
                          _buildCouponField(_couponController),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                                hoverColor: Colors.white,
                                value: _agreedToTerms,
                                onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.normal),
                                    children: [
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: TextStyle(color: Colors.orangeAccent),
                                      ),
                                      const TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(color: Colors.orangeAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          _isLoading
                              ? const CircularProgressIndicator()
                              : _buildGradientButton("Signup", _handleSignup, enabled: _agreedToTerms),
                        ],
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _pauseCarousel();
        } else {
          _resumeCarousel();
        }
      },
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily:'Poppins',fontSize: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }  
bool _isConfirmPasswordVisible = false;
  Widget _buildPasswordField(
  TextEditingController controller,
  String hint, {
  bool confirm = false,
}) {
  return Focus(
    onFocusChange: (hasFocus) {
      if (hasFocus) {
        _pauseCarousel();
      } else {
        _resumeCarousel();
      }
    },
    child: TextFormField(
      controller: controller,
      obscureText: confirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        if (!confirm && value.length < 6) return "Min 6 characters";
        if (confirm && value != _passwordController.text) return "Passwords don’t match";
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon:  Icon(confirm ? Icons.lock : Icons.vpn_key),
        suffixIcon: IconButton(
          icon: Icon(
            confirm
                ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          ),
          onPressed: () {
            setState(() {
              if (confirm) {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
      ),
    ),
  );
}
Widget _buildCouponField(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      
      controller: controller,
      decoration: InputDecoration(
         fillColor: Colors.grey[200],
        hintText: "Enter Coupon (Optional)",
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.grey
          
        ),
        filled: true,
       
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ), 
        suffixIcon: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 6,
          offset: const Offset(8, 4), 
        ),
      ],
           gradient: const LinearGradient(
              colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
            },
          ),
        ),
      ),
    ),
  );
}
  Widget _buildGradientButton(String text, VoidCallback? onTap, {bool enabled = true}) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
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
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

