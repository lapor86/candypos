
import 'dart:math';

import 'package:candypos/core/utils/constants/app_colors.dart';
import 'package:candypos/core/utils/constants/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../create_or_edit_bill/widgets/item_search_bar_widget.dart';
import '../providers/cart_item.dart';
import '../providers/pos_items_data_provider.dart';
import '../providers/pos_ui_provider.dart';
import '../providers/servicing_cart.dart';


class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  
  // String selectedCategoryName = 'All products';
  // String commonCategoryNameOfItem = 'All products';


  // List<Item> itemList = [];

  // List<Category> categoryList = [];

  // List<String> categoryNameList = [];


  // // functions
  
  // _populateCategoryMappedProductList() {
  //   itemList = context.watch<InventoryDataController>().itemListOfStore;
  //   categoryList = context.watch<InventoryDataController>().categoriesOfStore;
  //   categoryNameList = [];
  //   categoryNameList.add(commonCategoryNameOfItem);

  //   for(final category in categoryList) {
  //     categoryNameList.add(category.categoryName);
  //   }
  // }

  // List<ItemModel> getCategoryItems() {
  //   List<ItemModel> categoryItemList = [];
  //   for(final item in itemList) {
  //     if(item.categoryIdMapName.containsValue(selectedCategoryName) || selectedCategoryName == commonCategoryNameOfItem){
  //       categoryItemList.add(item);
  //     }
  //   }
  //   return categoryItemList;
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<ItemKind> categoryItemKinds = [];

  @override
  Widget build(BuildContext context) {
    categoryItemKinds = context.watch<PosUiProvider>().categoryItemKinds;

    return LayoutBuilder(
      builder: (context, constraints) {
        //return Container();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              
              child: ItemSearchBar(),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _categoryProducts(),
              ),
            )
          ],
        );
      },
    );
  }


  

  Widget _categoryProducts() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(categoryItemKinds.isEmpty) {
          return Center(
            child: Text('0 products', style: Theme.of(context).textTheme.labelLarge,),
          );
        }
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: GridView.builder(
            itemCount: categoryItemKinds.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 175,
              childAspectRatio: 4 / 5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ), 
            itemBuilder:(context, index) {
              return _gridItemWidget(item: categoryItemKinds[index],);
            },
          ),
        );
      }
    );
  }
  
  
  Widget _gridItemWidget({required ItemKind item}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomTextHeight = 20;
        final imageHeight = constraints.maxHeight - bottomTextHeight;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppColors.context(context).textColor,
            borderRadius: AppSizes.smallBorderRadius,
            onTap: () async{
              Future.delayed(Duration(milliseconds: 200)).then((_){
                if(item.variants.length == 1 && context.mounted) {
                  context.read<OpenedCart>().addItem(cartItem: item.variants.entries.first.value);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppSizes.smallBorderRadius,
              ),
              child: Column(
                children: [
                  item.image != null 
                  ? Image.memory(
                    item.image!,
                    height: imageHeight,
                    width: constraints.maxWidth - 2,
                  )
                  : Icon(Icons.image, size: min(constraints.maxHeight / 2, constraints.maxWidth), color: AppColors.context(context).contentBoxGreyColor,),
            
                  Text(item.itemName, style: Theme.of(context).textTheme.labelLarge,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}