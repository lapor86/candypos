// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../../inventory/unit/data/models/unit_model.dart';
import 'addon.dart';
import 'sale_discount.dart';

class SaleItem {
  final String itemId;

  final String variantId;

  final String? sku;

  final String? itemBarcode;

  final String itemName;

  final String variantName;

  final double price;

  final SaleDiscount? saleDiscount;

  final UnitModel unitDetails;

  final double quantity;

  final double totalPrice;

  final List<AddOn> addOns;

  final String note;

  SaleItem({
    required this.itemId,
    required this.variantId,
    required this.sku,
    required this.itemBarcode,
    required this.itemName,
    required this.variantName,
    required this.price,
    required this.saleDiscount,
    required this.unitDetails,
    required this.quantity,
    required this.totalPrice,
    required this.addOns,
    required this.note,
  });

  SaleItem copyWith({
    String? itemId,
    String? variantId,
    String? sku,
    String? itemBarcode,
    String? itemName,
    String? variantName,
    double? price,
    SaleDiscount? saleDiscount,
    UnitModel? unitDetails,
    double? quantity,
    double? totalPrice,
    List<AddOn>? billedModifierList,
    String? note,
  }) {
    return SaleItem(
      itemId: itemId ?? this.itemId,
      variantId: variantId ?? this.variantId,
      sku: sku ?? this.sku,
      itemBarcode: itemBarcode ?? this.itemBarcode,
      itemName: itemName ?? this.itemName,
      variantName: variantName ?? this.variantName,
      price: price ?? this.price,
      saleDiscount: saleDiscount ?? this.saleDiscount,
      unitDetails: unitDetails ?? this.unitDetails,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      addOns: billedModifierList ?? this.addOns,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'SaleItemInfo(itemId: $itemId, variantId: $variantId, sku: $sku, itemBarcode: $itemBarcode, itemName: $itemName, variantName: $variantName, price: $price, saleDiscount: $saleDiscount, unitDetails: $unitDetails, quantity: $quantity, totalPrice: $totalPrice, billedModifierList: $addOns, note: $note)';
  }

  @override
  bool operator ==(covariant SaleItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.itemId == itemId &&
      other.variantId == variantId &&
      other.sku == sku &&
      other.itemBarcode == itemBarcode &&
      other.itemName == itemName &&
      other.variantName == variantName &&
      other.price == price &&
      other.saleDiscount == saleDiscount &&
      other.unitDetails == unitDetails &&
      other.quantity == quantity &&
      other.totalPrice == totalPrice &&
      listEquals(other.addOns, addOns) &&
      other.note == note;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
      variantId.hashCode ^
      sku.hashCode ^
      itemBarcode.hashCode ^
      itemName.hashCode ^
      variantName.hashCode ^
      price.hashCode ^
      saleDiscount.hashCode ^
      unitDetails.hashCode ^
      quantity.hashCode ^
      totalPrice.hashCode ^
      addOns.hashCode ^
      note.hashCode;
  }
}
