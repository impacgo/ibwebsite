
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ironingboy/Screens/cartitem.dart';
// import 'package:ironingboy/Screens/checkoutpage.dart';
// import 'package:ironingboy/cartpage.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController notetaker = TextEditingController();
//   List<File> _pickedImages = [];

//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.gallery) {
//       // Pick multiple images
//       final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//       if (pickedFiles != null && pickedFiles.isNotEmpty) {
//         setState(() {
//           _pickedImages.addAll(pickedFiles.map((e) => File(e.path)));
//         });
//       }
//     } else {
//       // Pick single camera image
//       final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//       if (pickedFile != null) {
//         setState(() {
//           _pickedImages.add(File(pickedFile.path));
//         });
//       }
//     }
//     Navigator.pop(context); // close bottom sheet
//   }

//   void _showPickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.blue),
//               title: const Text("Camera"),
//               onTap: () => _pickImage(ImageSource.camera),
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Colors.green),
//               title: const Text("Gallery (Multiple)"),
//               onTap: () => _pickImage(ImageSource.gallery),
//             ),
//             ListTile(
//               leading: const Icon(Icons.close, color: Colors.red),
//               title: const Text("Cancel"),
//               onTap: () => Navigator.pop(ctx),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "My Cart",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: BlocBuilder<CartBloc, CartState>(
//         builder: (context, state) {
//           if (state is CartUpdated && state.items.isNotEmpty) {
//             final List<CartItem> items = state.items;
//             final grandTotal = items.fold<double>(0, (sum, e) => sum + e.totalPrice);
//             return Column(
//               children: [
//                 // cart 
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [      
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                      //emoji should load here  from api
//                                     Text(item.name,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                           fontFamily: 'Poppins',
//                                         )),
//                                     const SizedBox(height: 4),
//                                     Text("Price: ₹${item.price.toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w400,
//                                         )),
//                                     const SizedBox(height: 2),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           onPressed: () {
//                                             context.read<CartBloc>().add(UpdateQuantity(item, item.qty + 1));
//                                           },
//                                           icon: const Icon(Icons.add_circle, color: Colors.orange),
//                                         ),
//                                         Text(item.qty.toString().padLeft(2, "0"),
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600,
//                                             )),
//                                         IconButton(
//                                           onPressed: () {
//                                             if (item.qty > 1) {
//                                               context.read<CartBloc>().add(UpdateQuantity(item, item.qty - 1));
//                                             } else {
//                                               context.read<CartBloc>().add(RemoveFromCart(item));
//                                             }
//                                           },
//                                           icon: const Icon(Icons.remove_circle, color: Colors.orange),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text("Total: ₹${item.totalPrice.toStringAsFixed(2)}",
//                                       style: const TextStyle(
//                                         fontSize: 13,
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w600,
//                                       )),
//                                   const SizedBox(height: 25),
//                                   IconButton(
//                                     onPressed: () {
//                                       context.read<CartBloc>().add(RemoveFromCart(item));
//                                     },
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // Notes
//                 Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   child: TextFormField(
//     controller: notetaker,
//     minLines: 1, // starts with 1 line
//     maxLines: 5, // expands up to 5 lines, then scrolls
//     keyboardType: TextInputType.multiline,
//     decoration: InputDecoration(
//       hintText: "Write any notes for the laundry",
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     ),
//   ),
// ),


//                 // Image picker
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.upload_file, color: Colors.blue),
//                       const SizedBox(width: 6),
//                       TextButton(
//                         onPressed: () => _showPickerOptions(),
//                         child: const Text(
//                           "Upload Image",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Show selected images preview
//                 if (_pickedImages.isNotEmpty)
//                   SizedBox(
//                     height: 100,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(8),
//                       itemCount: _pickedImages.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 10),
//                       itemBuilder: (context, index) {
//                         return Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(
//                                 _pickedImages[index],
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _pickedImages.removeAt(index);
//                                   });
//                                 },
//                                 child: const CircleAvatar(
//                                   radius: 12,
//                                   backgroundColor: Colors.red,
//                                   child: Icon(Icons.close, color: Colors.white, size: 16),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),

//                 // Checkout button
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => CheckoutPage()),
//                         );
//                       },
//                       child: const Text(
//                         "Proceed to checkout",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(
//               child: Text(
//                 "Your cart is empty",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// cartpage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ironingboy/Screens/cartitem.dart';
import 'package:ironingboy/Screens/cartextra.dart';
import 'package:ironingboy/Screens/checkoutpage.dart';
import 'package:ironingboy/cartpage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController notetaker = TextEditingController();

  // local preview for camera-picked images while the bloc persists them.
  // We'll populate from the bloc state in initState and update from BlocBuilder.
  List<File> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    // Initialize controller & local images from CartExtraBloc if available
    final extraBloc = context.read<CartExtraBloc>();
    final state = extraBloc.state;
    notetaker.text = state.notes ?? '';
    _pickedImages = state.imagePaths.map((p) => File(p)).toList();
  }

  @override
  void dispose() {
    notetaker.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      // Pick multiple images
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (final xfile in pickedFiles) {
          final f = File(xfile.path);
          // dispatch to bloc which will persist to Hive and update state
          context.read<CartExtraBloc>().add(AddImage(f));
        }
      }
    } else {
      // Pick single camera image
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final f = File(pickedFile.path);
        context.read<CartExtraBloc>().add(AddImage(f));
      }
    }
    // close bottom sheet (if any)
    if (mounted) Navigator.pop(context);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text("Gallery (Multiple)"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return const Center(
      child: Text(
        "Your cart is empty",
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // Listen to extras to update local preview list when bloc changes
          BlocListener<CartExtraBloc, CartExtraState>(
            listener: (context, state) {
              setState(() {
                _pickedImages = state.imagePaths.map((p) => File(p)).toList();
                // keep note text in sync if changed elsewhere
                if (notetaker.text != (state.notes ?? '')) {
                  notetaker.text = state.notes ?? '';
                }
              });
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartUpdated && state.items.isNotEmpty) {
              final List<CartItem> items = state.items;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Price: ₹${item.price.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                        UpdateQuantity(
                                                            item, item.qty + 1),
                                                      );
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              Text(
                                                item.qty
                                                    .toString()
                                                    .padLeft(2, "0"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (item.qty > 1) {
                                                    context.read<CartBloc>().add(
                                                          UpdateQuantity(
                                                              item, item.qty - 1),
                                                        );
                                                  } else {
                                                    context
                                                        .read<CartBloc>()
                                                        .add(RemoveFromCart(
                                                            item));
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Total: ₹${item.totalPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        IconButton(
                                          onPressed: () {
                                            context
                                                .read<CartBloc>()
                                                .add(RemoveFromCart(item));
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: notetaker,
                                  minLines: 1,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText: "Write any notes for the laundry",
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.upload_file, color: Colors.blue),
                              const SizedBox(width: 6),
                              TextButton(
                                onPressed: _showPickerOptions,
                                child: const Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_pickedImages.isNotEmpty)
                          SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(8),
                              itemCount: _pickedImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final file = _pickedImages[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        file,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          context
                                              .read<CartExtraBloc>()
                                              .add(RemoveImage(index));
                                        },
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          context.read<CartExtraBloc>().add(SaveNotes(notetaker.text));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutPage(), 
                            ),
                          );
                        },
                        child: const Text(
                          "Proceed to checkout",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // cart empty
              return _buildEmptyCartView();
            }
          },
        ),
      ),
    );
  }
}