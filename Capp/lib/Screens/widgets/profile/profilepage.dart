import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/widgets/addresspage.dart';
import 'package:ironingboy/Screens/widgets/referandearn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ironingboy/Screens/widgets/personalinfo.dart';
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileTile(
            icon: Icons.person_outline,
            title: "Personal Info",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.my_location_outlined,
            title: "Address & Pickup Details",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddressListPage()),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.help_outline,
            title: "Support & Feedback",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportFeedbackScreen()),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.people_outline,
            title: "Refer and Earn",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferEarnPage()),
              );
            },
          ),
          _ProfileTile(
            icon: Icons.settings_outlined,
            title: "App Settings",
            onTap: () {
              Navigator.push(
      context,
      MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
      ),
      body: const Center(
        child: Text("Development in progress..."),
      ),
    ),
      ),
    );
            },
          ),
        ],
      ),
    );
  }
}

class SupportFeedbackScreen extends StatefulWidget {
  const SupportFeedbackScreen({super.key});

  @override
  State<SupportFeedbackScreen> createState() => _SupportFeedbackScreenState();
}

class _SupportFeedbackScreenState extends State<SupportFeedbackScreen> {
  final List<bool> _isExpanded = [false, false, false];
  int _selectedRating = -1;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (_selectedRating == -1 || _feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give rating and feedback.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://example.com/api/feedback"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rating": _selectedRating,
          "feedback": _feedbackController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback submitted successfully!")),
        );
        _feedbackController.clear();
        setState(() {
          _selectedRating = -1;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit feedback.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting feedback.")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Support & Feedback",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildExpansionTile(
                  0,
                  "Rating & Feedback",
                  _buildRatingFeedbackForm(),
                ),
                const SizedBox(height: 8),
                _buildExpansionTile(
                  1,
                  "FAQ's",
                  const _FaqSection(),
                ),
                const SizedBox(height: 8),
                _buildExpansionTile(
                  2,
                  "Contact Support",
                  const _ContactSupportSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingFeedbackForm() {
    final List<String> emojis = ["😢", "😟", "😐", "😊", "😍"];
    final List<String> labels = ["Terrible", "Bad", "Okay", "Good", "Awesome"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Share your Feedback",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        const Text(
          "Rate your Experience",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(emojis.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = index;
                });
              },
              child: Column(
                children: [
                  Text(emojis[index], style: const TextStyle(fontSize: 30)),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: _selectedRating == index ? FontWeight.bold : FontWeight.w400,
                      color: _selectedRating == index ? Colors.orange : Colors.black,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell us what you loved or what could be better...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8B500), Color(0xFFF57C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isSubmitting ? null : _submitFeedback,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildExpansionTile(int index, String title, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          _isExpanded[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded[index] = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          )
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _FaqItem(
          question: "How do I place an order?",
          answer: "You can place an order by selecting your items, adding them to the cart, and proceeding to checkout.",
        ),
        Divider(),
        _FaqItem(
          question: "What payment methods are accepted?",
          answer: "We accept all major credit/debit cards, UPI, and net banking.",
        ),
        Divider(),
        _FaqItem(
          question: "How can I track my order?",
          answer: "After placing your order, you can track it in the 'My Orders' section of the app.",
        ),
      ],
    );
  }
}

class _ContactSupportSection extends StatelessWidget {
  const _ContactSupportSection();

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.phone, color: Colors.black),
          title: const Text(
            "Call Us",
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            launchUrl(Uri.parse("tel:+919876543210"));
          },
        ),
        ListTile(
          leading: const Icon(Icons.email, color: Colors.black),
          title: const Text(
            "Email Support",
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            launchUrl(Uri.parse("mailto:info@ironingboy.com"));
          },
        ),
      ],
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                isExpanded ? Icons.remove : Icons.add,
                color: Colors.orange,
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 8),
          Text(
            widget.answer,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}