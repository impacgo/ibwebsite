import 'package:flutter_bloc/flutter_bloc.dart';
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Map<String, dynamic> product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Map<String, dynamic> product;
  RemoveFromCart(this.product);
}

class ClearCart extends CartEvent {}

class UpdateQuantity extends CartEvent {
  final Map<String, dynamic> product;
  final int newQty;
  UpdateQuantity(this.product, this.newQty);
}

// States
abstract class CartState {
  final List<Map<String, dynamic>> items;
  CartState(this.items);
}
class CartInitial extends CartState {
  CartInitial() : super([]);
}

class CartUpdated extends CartState {
  CartUpdated(List<Map<String, dynamic>> items) : super(items);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    // Add product
    on<AddToCart>((event, emit) {
      final updatedItems = List<Map<String, dynamic>>.from(state.items);

      // check if product already exists
      final index = updatedItems.indexWhere(
          (item) => item["id"] == event.product["id"]);

      if (index != -1) {
        updatedItems[index]["qty"] =
            (updatedItems[index]["qty"] ?? 1) + 1;
      } else {
        updatedItems.add({...event.product, "qty": 1});
      }
      emit(CartUpdated(updatedItems));
    });
    on<RemoveFromCart>((event, emit) {
      final updatedItems = List<Map<String, dynamic>>.from(state.items)
        ..removeWhere((item) => item["id"] == event.product["id"]);
      emit(CartUpdated(updatedItems));
    });
    on<ClearCart>((event, emit) {
      emit(CartUpdated([]));
    });
    on<UpdateQuantity>((event, emit) {
      final updatedItems = List<Map<String, dynamic>>.from(state.items);
      final index =
          updatedItems.indexWhere((item) => item["id"] == event.product["id"]);
      if (index != -1) {
        if (event.newQty > 0) {
          updatedItems[index]["qty"] = event.newQty;
        } else {
          updatedItems.removeAt(index);
        }
      }
      emit(CartUpdated(updatedItems));
    });
  }
}
