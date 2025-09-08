import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ironingboy/Screens/cartextra.dart';
import 'package:ironingboy/Screens/cartitem.dart';


// Events
abstract class CartEvent {}
class ClearCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final CartItem item;
  RemoveFromCart(this.item);
}

class UpdateQuantity extends CartEvent {
  final CartItem item;
  final int qty;
  UpdateQuantity(this.item, this.qty);
}

class HideCartBar extends CartEvent {}

abstract class CartExtraEvent {}
class SaveNotes extends CartExtraEvent {
  final String notes;
  SaveNotes(this.notes);
}
class AddImage extends CartExtraEvent {
  final File image;
  AddImage(this.image);
}
class RemoveImage extends CartExtraEvent {
  final int index;
  RemoveImage(this.index);
}
class ClearExtras extends CartExtraEvent {}


// States
class CartExtraState {
  final String? notes;
  final List<String> imagePaths;

  const CartExtraState({this.notes, this.imagePaths = const []});

  CartExtraState copyWith({String? notes, List<String>? imagePaths}) {
    return CartExtraState(
      notes: notes ?? this.notes,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}
abstract class CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;
   final bool showBar;
  CartUpdated(this.items,{this.showBar = true});
}
class CartExtraBloc extends Bloc<CartExtraEvent, CartExtraState> {
  final Box<CartExtra> extraBox = Hive.box<CartExtra>('cartExtraBox');

  CartExtraBloc() : super(const CartExtraState()) {
    if (extraBox.isNotEmpty) {
      final extra = extraBox.values.first;
      emit(CartExtraState(notes: extra.notes, imagePaths: extra.imagePaths ?? []));
    }

    on<SaveNotes>((event, emit) async {
      final current = state.copyWith(notes: event.notes);
      await _saveToHive(current);
      emit(current);
    });

    on<AddImage>((event, emit) async {
      final updated = List<String>.from(state.imagePaths)..add(event.image.path);
      final current = state.copyWith(imagePaths: updated);
      await _saveToHive(current);
      emit(current);
    });

    on<RemoveImage>((event, emit) async {
      final updated = List<String>.from(state.imagePaths)..removeAt(event.index);
      final current = state.copyWith(imagePaths: updated);
      await _saveToHive(current);
      emit(current);
    });

    on<ClearExtras>((event, emit) async {
      await extraBox.clear();
      emit(const CartExtraState());
    });
  }

  Future<void> _saveToHive(CartExtraState state) async {
    await extraBox.clear();
    await extraBox.add(
      CartExtra(notes: state.notes, imagePaths: state.imagePaths),
    );
  }
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final Box<CartItem> cartBox = Hive.box<CartItem>('cartBox');

  CartBloc() : super(CartUpdated(Hive.box<CartItem>('cartBox').values.toList())) {
 
    on<AddToCart>((event, emit) {
 
  final exists = cartBox.values.any((e) => e.id == event.item.id);

  if (!exists) {
    cartBox.add(event.item); 
  }

  emit(CartUpdated(cartBox.values.toList()));
});

    on<RemoveFromCart>((event, emit) async {
      await event.item.delete();
      emit(CartUpdated(cartBox.values.toList()));
    });

     on<HideCartBar>((event, emit) {
  if (state is CartUpdated) {
    final currentItems = (state as CartUpdated).items;
    emit(CartUpdated(currentItems, showBar: false));
  }
});

    on<UpdateQuantity>((event, emit) async {
      if (event.qty <= 0) {
        await event.item.delete();
      } else {
        event.item.qty = event.qty;
        await event.item.save();
      }
      emit(CartUpdated(cartBox.values.toList()));
    });

    on<ClearCart>((event, emit) async {
  await cartBox.clear(); 
  emit(CartUpdated([])); 
});

  }
}
