// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockHistoryModelAdapter extends TypeAdapter<StockHistoryModel> {
  @override
  final int typeId = 1;

  @override
  StockHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockHistoryModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      change: fields[3] as int,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.change)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
