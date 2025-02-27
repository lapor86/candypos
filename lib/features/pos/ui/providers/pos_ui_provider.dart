import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'cart_item.dart';
import 'pos_items_data_provider.dart';
import 'servicing_cart.dart';



class PosUiProvider extends ChangeNotifier {

  late final OpenedCart _currentCart;
  OpenedCart get currentCart => _currentCart;

  final SplayTreeMap<String, ItemKind> _itemKinds =
      SplayTreeMap<String, ItemKind>();

  UnmodifiableListView<ItemKind> get categoryItemKinds => UnmodifiableListView(_itemKinds.values);

  List<String> _categories = ["All products"];
  UnmodifiableListView<String> get categories => UnmodifiableListView(_categories);

  late String _currentCategory;
  String get currentCategory => _currentCategory;

  PosUiProvider(){
    _currentCart = OpenedCart.init();
    _currentCategory = _categories.first;
  }

  


  void setCurrentCategory(int index){
    if(index >= _categories.length || index < 0) return;
    _currentCategory = categories[index]; notifyListeners();
  }

  

  /// Updates or add variants which's `itemId` matches with GroupedOrderItems's `itemId` that are added before.
  ///
  /// Make sure the GroupedOrderItems of every variants on the list (`List<OrderItem>`) of this method's parameter is added before.
  void updateVariants(List<CartItem> variants) {
    for (final variant in variants) {
      if (_itemKinds.containsKey(variant.itemId)) {
        _itemKinds[variant.itemId]!.updateVariant(variant);
      }
    }
  }

  void addGroupedOrderItems(List<ItemKind> items) {
    for (final item in items) {
      if (!_itemKinds.containsKey(item.itemId)) {
        _itemKinds[item.itemId] = item;
      }
    }
  }
}