
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
part 'cartextra.g.dart';

@HiveType(typeId: 2)  
class CartExtra extends HiveObject {
  @HiveField(0)
  String? notes;

  @HiveField(1)
  List<String>? imagePaths; 

  CartExtra({this.notes, this.imagePaths});
}
