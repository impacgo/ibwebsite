// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartextra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartExtraAdapter extends TypeAdapter<CartExtra> {
  @override
  final int typeId = 2;

  @override
  CartExtra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartExtra(
      notes: fields[0] as String?,
      imagePaths: (fields[1] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartExtra obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.notes)
      ..writeByte(1)
      ..write(obj.imagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
