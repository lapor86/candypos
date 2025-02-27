import 'dart:typed_data';
import 'cart_item.dart';

class ItemKind  {
  final String itemId;
  final String itemName;
  List<String> categories;
  final Uint8List? image;
  final double primaryPrice;
  final int posIndex;

  Map<String, CartItem> _variants;
  Map<String, CartItem> get variants => Map<String, CartItem>.fromEntries(
      _variants.entries.map((e) => MapEntry(e.key, e.value.copyWith())));

  ItemKind({
    required this.itemId,
    required this.itemName,
    required this.posIndex,
    required this.primaryPrice,
    required this.image,
    required this.categories,
    required Map<String, CartItem> variants,
  }) : _variants = variants{
    assert(variants.isNotEmpty);
  }

  /// Adds the variant if not included yet, otherwise update with the existing variant.
  updateVariant(CartItem variant) {

    assert(variant.itemId != itemId);

    _variants[variant.variantId] = variant;
  }
}

