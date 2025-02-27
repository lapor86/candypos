
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/pos/ui/pages/pos_ui.dart';
import '../pages/inventory_page.dart';
import '../providers/appdrawer_controller.dart';
import '../pages/appdrawer.dart';

class SelectedAppPage extends StatelessWidget {
  
  const SelectedAppPage({super.key,});

  

  @override
  Widget build(BuildContext context) {
    AppDrawerTabState appDrawerTabState = AppDrawerTabState.pos;
    appDrawerTabState = context.watch<AppdrawerStateController>().selectedAppDrawerTab;

    switch (appDrawerTabState) {
      case AppDrawerTabState.pos:
        return PosUi();
      case AppDrawerTabState.inventory:
        return InventoryPage();
      case AppDrawerTabState.expenses:
        return Scaffold();
      case AppDrawerTabState.analysis:
        return Scaffold();
      case AppDrawerTabState.settings:
        return Scaffold();
      }
  }
}