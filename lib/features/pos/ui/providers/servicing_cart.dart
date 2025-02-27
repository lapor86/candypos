import 'package:candypos/core/utils/uuid_service/firebase_uid.dart';
import 'package:candypos/features/pos/domain/entities/pos_settings.dart';
import 'package:candypos/core/common/notifiers/save_status_provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/common/domains/upload_meta.dart';
import '../../../../core/common/enums/common_enums.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../auth/domain/entities/user_auth.dart';
import '../../domain/entities/addon.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/delivery_info.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/sale_customer.dart';
import '../../domain/entities/sale_discount.dart';
import '../../domain/entities/sale_item.dart';
import '../../domain/entities/sale_tax.dart';
import 'cart_item.dart';
import 'item_add_on.dart';

// enum DataType{
//   string, num
// }

// class RangeConditionData {
//   String columnName;
//   double min;
//   double max;
//   /// Convertable to num(double) value.
//   String data;

//   RangeConditionData({required this.columnName, required this.min, required this.max, required this.data}){
//     assert (max >= min);
//   }

// }

// enum CompareTo{
//   equal,
//   greater,
//   smaller,
//   equalOrGreater,
//   equalOrSmaller
// }

// class CompareConditionData {
//   String columnName;
//   double value;
//   CompareTo compareTo;
//   /// Convertable to num(double) value.
//   String data;

//   CompareConditionData({required this.columnName, required this.value, required this.compareTo, required this.data});

// }

// class Column{
//   String name;
//   DataType dataType;
//   String defaultData;
// }

// class TableSchema{
//   String name;
//
// }

extension on ItemAddOn {
  AddOn toAddOn(ItemAddOn itemAddOn) {
    return AddOn(
      name: itemAddOn.name,
      price: itemAddOn.price,
      quantity: itemAddOn.quantity,
    );
  }
}

extension on CartItem {
  SaleItem toSaleItem(CartItem cartItem) {
    return SaleItem(
      itemId: cartItem.itemId,
      variantId: cartItem.variantId,
      sku: cartItem.sku,
      itemBarcode: cartItem.itemBarcode,
      itemName: cartItem.itemName,
      variantName: cartItem.variantName,
      price: cartItem.price,
      saleDiscount: null,
      unitDetails: cartItem.unitDetails,
      quantity: cartItem.quantity,
      totalPrice: cartItem.totalPrice,
      addOns: cartItem.addedAddOns.map((e) => e.toAddOn(e)).toList(),
      note: cartItem.note,
    );
  }
}

class OpenedCart extends ChangeNotifier {
  late Key _key;

  PosSettings? _posSettings;

  late SaveStatusNotifier _saveStatusNotifier;
  SaveStatusNotifier get saveStatusNotifier => _saveStatusNotifier;

  String _billId;

  ServiceType _serviceType;
  ServiceType get serviceType => _serviceType;
  set serviceType(ServiceType serviceType) {
    if (serviceType == _serviceType) return;
    _serviceType = serviceType;
    notifyListeners();
  }

  List<String> _servicedByIds;
  List<String> get servicedByIds => _servicedByIds;

  CustomerInfo? _customerInfo;
  CustomerInfo? get customerInfo => _customerInfo;
  set customerInfo(CustomerInfo? customerInfo) {
    _customerInfo = customerInfo;
    notifyListeners();
  }

  List<SaleItem> _saleItemList;
  List<SaleItem> get saleItemList => _saleItemList;

  double _subTotal;
  double get subTotal => _subTotal;

  SaleDiscount? _saleDiscount;
  SaleDiscount? get saleDiscount => _saleDiscount;

  Map<int, SaleTax> _idMappedTax;
  Map<int, SaleTax> get idMappedTax => _idMappedTax;

  double _grandTotal;
  double get grandTotal => _grandTotal;

  List<Payment> _paymentList;
  List<Payment> get paymentList => _paymentList;

  double _totalPaid;
  double get totalPaid => _totalPaid;

  double _dueAmount;
  double get dueAmount => _dueAmount;

  DeliveryInfo? _deliveryInfo;
  DeliveryInfo? get deliveryInfo => _deliveryInfo;

  UploadMeta? _uploadMetaDetails;
  UploadMeta? get uploadMetaDetails => _uploadMetaDetails;

  double _totalDiscountAmount = 0;

  double _totalTax = 0;
  double get totalTax => _totalTax;

  static OpenedCart? _instance;

  OpenedCart._({
    required PosSettings? posSettings,
    required String billId,
    required ServiceType serviceType,
    required List<String> servicedByIds,
    required CustomerInfo? customerInfo,
    required List<SaleItem> saleItemList,
    required double subTotal,
    required SaleDiscount? saleDiscount,
    required Map<int, SaleTax> idMappedTax,
    required double grandTotal,
    required List<Payment> paymentList,
    required double totalPaid,
    required double dueAmount,
    required DeliveryInfo? deliveryInfo,
    required UploadMeta? uploadMetaDetails,
  })  : _posSettings = posSettings,
        _billId = billId,
        _serviceType = serviceType,
        _servicedByIds = servicedByIds,
        _customerInfo = customerInfo,
        _saleItemList = saleItemList,
        _subTotal = subTotal,
        _saleDiscount = saleDiscount,
        _idMappedTax = idMappedTax,
        _grandTotal = grandTotal,
        _paymentList = paymentList,
        _totalPaid = totalPaid,
        _dueAmount = dueAmount,
        _deliveryInfo = deliveryInfo,
        _uploadMetaDetails = uploadMetaDetails {
    _key = Key("Cart${DateTime.now().toIso8601String()}");
    _saveStatusNotifier = SaveStatusNotifier(_key);
  }

  factory OpenedCart.init({Cart? savedCart, PosSettings? settings}) {
    if (savedCart != null) {
      _instance = OpenedCart._(
        posSettings: settings,
        billId: savedCart.id,
        serviceType: savedCart.serviceType,
        servicedByIds: savedCart.servicedByIds,
        customerInfo: savedCart.customerInfo,
        saleItemList: savedCart.saleItemList,
        subTotal: savedCart.subTotal,
        saleDiscount: savedCart.saleDiscount,
        idMappedTax: savedCart.idMappedTax,
        grandTotal: savedCart.grandTotal,
        paymentList: [],
        totalPaid: 0,
        dueAmount: savedCart.grandTotal,
        deliveryInfo: savedCart.deliveryInfo,
        uploadMetaDetails: savedCart.uploadMetaDetails,
      );
      return _instance!;
    }

    _instance = _instance ??
        OpenedCart._(
          posSettings: null,
          billId: uuidByFirebaseSdk(),
          serviceType: ServiceType.inStore,
          servicedByIds: [],
          customerInfo: null,
          saleItemList: [],
          subTotal: 0,
          saleDiscount: null,
          idMappedTax: {},
          grandTotal: 0,
          paymentList: [],
          totalPaid: 0,
          dueAmount: 0,
          deliveryInfo: null,
          uploadMetaDetails: null,
        );
    return _instance!;
  }

  /// process =>>
  ///
  /// _doSubtotal();
  ///
  /// _doDiscount();
  ///
  /// _grandTotal = _subTotal - _totalDiscountAmount + _totalTax + _deliveryCharge;
  ///
  /// _doBalance();
  void doTotal() {
    _doSubtotal();
    _doDiscount();
    _grandTotal = _subTotal -
        _totalDiscountAmount +
        _totalTax +
        (deliveryInfo?.deliveryCharge ?? 0);
    _doBalance();
  }

  void _doBalance() {
    double totalPaidAmount = 0;
    for (final payment in paymentList) {
      totalPaidAmount += payment.amount;
    }
    _totalPaid = totalPaidAmount;
    _dueAmount = _grandTotal - _totalPaid;
  }

  void _doSubtotal() {
    _subTotal = 0;
    dekhao("before adding $_subTotal");
    for (final saleItem in saleItemList) {
      _subTotal += saleItem.totalPrice;
      dekhao("adding ${saleItem.price} , after adding $_subTotal");
    }
  }

  void _doDiscount() {
    _totalDiscountAmount = (_saleDiscount == null
        ? 0
        : _saleDiscount!.discountType == DiscountType.flat
            ? _saleDiscount!.discountValue
            : (_subTotal * (_saleDiscount!.discountValue / 100)));
  }

  void setCustomer({required CustomerInfo? customerInfo}) {
    _customerInfo = customerInfo;
    notifyListeners();
  }

  /// Returns true, if dueAmount > 0 and adding payment's paidAmount > 0.
  /// Otherwise, returns false
  bool addPayment({required Payment payment}) {
    if (dueAmount > 0 && payment.amount > 0) {
      _paymentList.add(payment);
      _doBalance();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void removeAllItems() {
    _saleItemList = [];
    doTotal();
  }

  void addItem({required CartItem cartItem}) {
    _saleItemList.add(cartItem.toSaleItem(cartItem));
    doTotal();
    notifyListeners();
  }

  ///Increment the BilledItem quantity value by the incrementBy parameter of the function.
  ///
  ///If the index is not valid or the BilledItem's kiloLitreItem field is not true,
  ///then the function does not accept decimal point number and doesn't perform increment action.
  void editItemAt({required SaleItem saleItem, required int index}) {
    if (_saleItemList.length - 1 < index || index < 0) {
      return;
    }
    _saleItemList[index] = saleItem;
    doTotal();
  }

  /// The [index] must be in the range `0 ≤ index < length`.
  /// The list must be growable.
  void removeItemAt({required int index}) {
    if (_saleItemList.length - 1 < index || index < 0) {
      return;
    }
    _saleItemList.removeAt(index);
    doTotal();
  }

  bool _saleItemListIndexError(int index) {
    if (index < 0 || _saleItemList.length - 1 < index) {
      return false;
    }
    return true;
  }

  /// If returns null, it means ready to checkout;
  /// Else returns the error.
  String? _checkIfCanCheckout() {
    if (_billId.isEmpty) {
      if (_saveStatusNotifier.saveStatus != SaveStatus.canNotSave) {
        _saveStatusNotifier.setSaveStatus(_key, SaveStatus.canNotSave);
      }
      return "Order's bill id is null!";
    }

    if (saleItemList.isEmpty) {
      if (_saveStatusNotifier.saveStatus != SaveStatus.canNotSave) {
        _saveStatusNotifier.setSaveStatus(_key, SaveStatus.canNotSave);
      }
      return "Can't checkout with an empty cart";
    }

    final deliveryError = _deliveryInfoFilled();

    if (deliveryError != null) {
      if (_saveStatusNotifier.saveStatus != SaveStatus.canNotSave) {
        _saveStatusNotifier.setSaveStatus(_key, SaveStatus.canNotSave);
      }
      return deliveryError;
    }

    if (_saveStatusNotifier.saveStatus != SaveStatus.canSave) {
      _saveStatusNotifier.setSaveStatus(_key, SaveStatus.canSave);
    }
  }

  String? _deliveryInfoFilled() {
    if (_serviceType == ServiceType.delivery) {
      if (_deliveryInfo == null) {
        return "Delivery info is not set.";
      }

      if (_customerInfo == null) {
        return "Customer info is not set.";
      }
    }
    return null;
  }

  Future<void> checkout(UserAuth auth) async {
    _checkIfCanCheckout();
    if (_saveStatusNotifier.saveStatus != SaveStatus.canSave) return;
  }
}
