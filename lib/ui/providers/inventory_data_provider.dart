import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:candypos/core/usecases/usecases.dart';
import 'package:candypos/core/utils/func/dekhao.dart';
import 'package:candypos/init_dependency.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../features/image/domain/usecases/fetch_image.dart';
import '../../features/inventory/category/domain/entities/category.dart';
import '../../features/inventory/item/domain/entities/item.dart';
import '../../features/inventory/item/domain/usecases/fetch_synced_items.dart';

class InventoryDataProvider extends ChangeNotifier{
  StreamSubscription<List<Item>>? _itemSubscription;

  final SplayTreeMap<String, Item> _inventoryItems = SplayTreeMap<String, Item>();

  final SplayTreeMap<String, ItemCategory> _categories = SplayTreeMap<String, ItemCategory>();

  List<Item> get allItems => _inventoryItems.entries.map((e) => e.value.copyWith()).toList();

  Map<String, String> get allCategories => _categories.map((k, v) => MapEntry(k, v.name));
  
  SplayTreeMap<String, Uint8List> _itemImages = SplayTreeMap<String, Uint8List>();
  SplayTreeMap<String, Uint8List> get itemImages => SplayTreeMap<String, Uint8List>.from(_itemImages);
  SplayTreeMap<String, Uint8List> _categoryImages = SplayTreeMap<String, Uint8List>();
  SplayTreeMap<String, Uint8List> get categoryImages => SplayTreeMap<String, Uint8List>.from(_categoryImages);


  InventoryDataProvider._();

  

  static InventoryDataProvider? _instance;

  static InventoryDataProvider get instance{
    _instance ??= InventoryDataProvider._();
    return _instance!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_itemSubscription != null) {
      _itemSubscription?.cancel();
    }
    super.dispose();
  }
  

  Future<void> init() async{
    _inventoryItemsStream();
  }

  _inventoryItemsStream() {

    serviceLocator<FetchItems>().call(NoParams()).fold(
      (l){

      }, (r) {
        _itemSubscription = r.listen(
          (items) async{
            dekhao("items stream len ${items.length}");
            for(final item in items) {
              _inventoryItems[item.id] = item;
              await getItemImage(storageRef: item.imageUrl, itemId: item.id);
            }
            notifyListeners();
          }
        );
        
      });
  }


  Future<void> getItemImage({required Reference storageRef, required String itemId}) async{
    return await serviceLocator<FetchImage>().call(FetchImageParams(storageRef: storageRef)).then((result) {
      return result.fold(
        (l){
          return null;
        }, (r){
          _itemImages[itemId] = r.image; notifyListeners();
        });
    });
  }

  updateItemImage({required String itemId, required Reference ref, required Uint8List image}) {
    if(_inventoryItems.containsKey(itemId) && _inventoryItems[itemId]!.imageUrl == ref){
      _itemImages[itemId] = image; notifyListeners();
    }
  }

  Uint8List? itemImage({required String itemId}) {
    return _itemImages[itemId];
  }

}