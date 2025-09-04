import 'package:hive/hive.dart';
part 'cartitem.g.dart';


@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price; // unit price

  @HiveField(3)
  int qty;

  // optional emoji field

 

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.qty = 1,
    
 
  
  });

  double get totalPrice => price * qty;
}
