import 'dart:math';
import 'package:candypos/features/pos/ui/providers/pos_ui_provider.dart';
import 'package:candypos/features/pos/ui/widgets/cart_mobile_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../widgets/change_billtype_action_popup.dart';
import '../widgets/hold_bill_action_popup.dart';

class PosUi extends StatefulWidget {
  const PosUi({super.key});

  @override
  State<PosUi> createState() => _PosUiState();
}

class _PosUiState extends State<PosUi> with TickerProviderStateMixin{

  late TabController _tabController ;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final currentCart = context.watch<PosUiProvider>().currentCart;
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: _body()
            ),
          );
        },
      );
  }

  Widget _body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double barHeight = 50;
        double tabHeight = constraints.maxHeight - barHeight;
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CartBriefWidget(),
            ),
            SizedBox(
              height: barHeight,
              width: constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                child: Center(child: _tabBar()),
              )
            ),
            SizedBox(
              width: constraints.maxWidth,
              // child: TabBarView(
              //   controller: _tabController,
              //   // : (value) {
              //   //   setState(() {
              //   //     currentTabIndex = value;
              //   //   });
              //   // },
              //   children: const [
              //     KeypadTab(),
              //     ItemsTab(),
              //   ],
              // ),
            ),
            
          ],
        );
          
      },
    );
  }


  Widget _tabBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: AppColors.context(context).contentBoxGreyColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                labelColor: AppColors.context(context).textColor.withOpacity(.9),
                labelStyle: TextStyle(fontSize: min(constraints.maxHeight, constraints.maxWidth) / 3, fontWeight: FontWeight.w500),
                indicatorSize: TabBarIndicatorSize.tab,
                //indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                indicator: BoxDecoration(
                  color: AppColors.context(context).backgroundColor,
                  borderRadius: BorderRadius.circular(8)
                ),
                //controller: ,
                //isScrollable: true,
                onTap: (value) {
                  // setState(() {
                  //   currentTabIndex = value;
                  // });
                },
                tabs:  [
                  Tab(text: 'Keypad', height: constraints.maxHeight,),
                  Tab(text: 'Items', height: constraints.maxHeight,),
                ],
              ),
            
            ),
          ),
        );
      },
    );
  }
}