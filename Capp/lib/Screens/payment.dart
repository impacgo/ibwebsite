// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:ironingboy/Screens/confirmorder.dart';
// import 'dart:convert';
// import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';
// class PaymentScreen extends StatefulWidget {
//   final double amount;
//   const PaymentScreen({super.key, required this.amount});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Map<String, dynamic>? paymentIntentData;
//   CardFieldInputDetails? cardDetails;
//   bool isLoading = false;
//   String? errorMessage;

//   Future<void> makePayment(BuildContext context) async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

     
//       int paiseAmount = (widget.amount * 100).toInt();
//       if (paiseAmount < 3000) {
//         paiseAmount = 3000;
//       }

      
//       paymentIntentData = await createPaymentIntent(
//         paiseAmount.toString(),
//         'INR',
//       );

  
//       final paymentMethod = await Stripe.instance.createPaymentMethod(
//         params: const PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(),
//         ),
//       );


//       await Stripe.instance.confirmPayment(
//         paymentIntentClientSecret: paymentIntentData!['client_secret'],
//         data: PaymentMethodParams.cardFromMethodId(
//           paymentMethodData: PaymentMethodDataCardFromMethod(
//             paymentMethodId: paymentMethod.id,
//           ),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment Successful!')),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OrderPlacedScreen() ),
//       );
//     } on StripeException catch (e) {
//       debugPrint('Payment failed: ${e.error.localizedMessage}');
//       setState(() {
//         errorMessage = e.error.localizedMessage;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment Failed: ${e.error.localizedMessage}')),
//       );
//     } catch (e) {
//       debugPrint("Unexpected error: $e");
//       setState(() {
//         errorMessage = 'Unexpected error: $e';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//   Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     final url = Uri.parse('${base.baseUrl}/create-payment-intent');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'amount': amount, 'currency': currency}),
//     );
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to create payment intent: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Payment',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.blueAccent,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Amount to Pay:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     '£${widget.amount.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Enter Card Details',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),
//             CardField(
//               onCardChanged: (details) {
//                 setState(() {
//                   cardDetails = details;
//                   errorMessage = null;
//                 });
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey[400]!),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 hintText: 'Card number, expiry, CVC',
//                 contentPadding: const EdgeInsets.all(16),
//               ),
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Text(
//                   errorMessage!,
//                   style: const TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             if (cardDetails != null && cardDetails!.complete)
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Card Details',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Card Number: **** **** **** ${cardDetails!.last4 ?? 'N/A'}',
//                       style: const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                     Text(
//                       'Expiry: ${cardDetails!.expiryMonth?.toString().padLeft(2, '0') ?? 'N/A'}/${cardDetails!.expiryYear ?? 'N/A'}',
//                       style: const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                     Text(
//                       'CVC: ***',
//                       style: const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: isLoading || (cardDetails?.complete != true)
//                     ? null
//                     : () => makePayment(context),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                 ),
//                 child: isLoading
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         'Pay £${widget.amount.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:ironingboy/Screens/confirmorder.dart';
import 'dart:convert';
import 'package:ironingboy/bussinesslogic/commonbaseurl.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntentData;
  CardFieldInputDetails? cardDetails;
  bool isLoading = false;
  String? errorMessage;
  bool saveCard = false;

  // Dummy saved cards for UI-only representation
  final List<Map<String, String>> savedCards = [
    {
      "brand": "mastercard",
      "masked": ".... .... .... 4321",
      "exp": "08/27",
    },
    {
      "brand": "visa",
      "masked": ".... .... .... 2210",
      "exp": "02/29",
    },
  ];

  Future<void> makePayment(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      int paiseAmount = (widget.amount * 100).toInt();
      if (paiseAmount < 3000) {
        paiseAmount = 3000;
      }

      paymentIntentData = await createPaymentIntent(
        paiseAmount.toString(),
        'INR',
      );

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
            paymentMethodId: paymentMethod.id,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderPlacedScreen()),
      );
    } on StripeException catch (e) {
      debugPrint('Payment failed: ${e.error.localizedMessage}');
      setState(() {
        errorMessage = e.error.localizedMessage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
      setState(() {
        errorMessage = 'Unexpected error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    final url = Uri.parse('${base.baseUrl}/create-payment-intent');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount, 'currency': currency}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create payment intent: ${response.body}');
    }
  }

  int _selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFF7A18); // main brand color to match image
    final canPay = (cardDetails?.complete == true) && !isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Card Details',
          style: TextStyle(
            color: orange,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: canPay ? () => makePayment(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'pay £${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saved Cards header
                const Text(
                  'Saved Cards',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: savedCards.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) {
                      final card = savedCards[idx];
                      final isSelected = idx == _selectedCardIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCardIndex = idx);
                        },
                        child: Container(
                          width: 260,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? orange : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // top row: brand and select circle
                              Row(
                                children: [
                                 
                                  if (card["brand"] == "mastercard")
                                    Container(
                                      width: 44,
                                      height: 28,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.circle, size: 18, color: Colors.redAccent),
                                    )
                                  else
                                    Container(
                                      width: 44,
                                      height: 28,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.credit_card, size: 18, color: Colors.blueAccent),
                                    ),
                                  const Spacer(),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: orange, width: 2),
                                      color: isSelected ? orange : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // masked number
                              Text(
                                card["masked"] ?? '.... .... .... 1234',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text('Exp: ${card["exp"]}',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
        
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Remove card'),
                                          content: const Text('Remove this saved card from your account?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                            TextButton(onPressed: () {
                                              Navigator.pop(ctx);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Development in progress')));
                                            }, child: const Text('Remove')),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text('Remove', style: TextStyle(fontSize: 12, color: Colors.blue)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

                // New card section title
                const Text(
                  'New card',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // New card container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      
                      CardField(
                        onCardChanged: (details) {
                          setState(() {
                            cardDetails = details;
                            errorMessage = null;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '1234 5678 9012 3456',
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cardDetails != null && cardDetails!.complete
                                  ? 'Card Number: **** **** **** ${cardDetails!.last4 ?? 'N/A'}'
                                  : 'Card number, Expiry, CVC',
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                          if (cardDetails != null && cardDetails!.complete)
                            Text(
                              'Expiry: ${cardDetails!.expiryMonth?.toString().padLeft(2, '0') ?? 'N/A'}/${cardDetails!.expiryYear ?? 'N/A'}',
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

               
                GestureDetector(
                  onTap: () => setState(() => saveCard = !saveCard),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: saveCard ? orange : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: saveCard ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                      ),
                      const SizedBox(width: 10),
                      const Text('Save card Details', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

               
                if (errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),

                const SizedBox(height: 24),

             
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount to Pay:',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '£${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}