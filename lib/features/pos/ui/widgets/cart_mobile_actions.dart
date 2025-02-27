import '../../../../core/common/enums/common_enums.dart';
import 'charge_button.dart';
import 'hold_bill_action_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../providers/servicing_cart.dart';
import 'change_billtype_action_popup.dart';
import 'checkout_button.dart';

class CartBriefWidget extends StatefulWidget {
  const CartBriefWidget({super.key});

  @override
  State<CartBriefWidget> createState() => _CartBriefWidgetState();
}

class _CartBriefWidgetState extends State<CartBriefWidget> {

  late OpenedCart cartProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var saveStatusNotifier = context.read<OpenedCart>().saveStatusNotifier;
    return ListenableBuilder(
      listenable: saveStatusNotifier,
      builder: (context, child) {

        saveStatusNotifier = context.read<OpenedCart>().saveStatusNotifier;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              //height: 80,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: saveStatusNotifier.saveStatus == SaveStatus.canSave
                ? AppColors.context(context).accentColor
                : AppColors.context(context).textGreyColor,
                //borderRadius: AppSizes.smallBorderRadius
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Table(
                  columnWidths: {0: FlexColumnWidth(.5), 1: FlexColumnWidth(.5)},
                  border: TableBorder(
                    verticalInside: BorderSide(
                      color: AppColors.context(context).buttonTextColor
                    )
                  ),
                  children: [
                    TableRow(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        ChargeButton(),
                        //Container(),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ChangeBilltypeActionPopup(),
                            HoldBillActionPopup()
                          ],
                        ),
                    
                        
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }


}