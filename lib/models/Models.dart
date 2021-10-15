import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Controller {
  String documentId;
  int version;
  Controller({this.documentId, this.version});
}

class Lounges {
  List category;
  String name;
  String id;
  String images;
  double longitude;
  double latitude;
  String lounge;
  String documentId;
  bool active;
  bool weAreOpen;
  double deliveryRadius;
  bool needsVerification;
  Lounges(
      {this.name,
      this.images,
      this.id,
      this.latitude,
      this.longitude,
      this.category,
      this.lounge,
      this.documentId,
      this.active,
      this.weAreOpen,
      this.deliveryRadius,
      this.needsVerification});
}

class OrdersCarrier {
  String information;
  List food;
  List price;
  List quantity;
  double subTotal;
  int tip;
  double serviceCharge;
  double deliveryFee;
  String loungeName;
  var created;
  bool isTaken;
  String orderCode;
  String userName;
  String userPhone;
  String documentId;
  String loungeId;
  double longitude;
  double latitude;
  double loungeLongitude;
  double loungeLatitude;

  double distance;
  String loungeOrderNumber;
  bool isPaid;

  OrdersCarrier(
      {this.food,
      this.information,
      this.price,
      this.quantity,
      this.loungeName,
      this.created,
      this.isTaken,
      this.orderCode,
      this.userName,
      this.userPhone,
      this.documentId,
      this.loungeId,
      this.latitude,
      this.longitude,
      this.deliveryFee,
      this.distance,
      this.loungeOrderNumber,
      this.tip,
      this.loungeLatitude,
      this.loungeLongitude,
      this.isPaid,
      this.serviceCharge,
      this.subTotal});
}

class Orders {
  String information;
  List food;
  List price;
  List quantity;
  double subTotal;
  int tip;
  double serviceCharge;
  double deliveryFee;
  String loungeName;
  var created;
  bool isTaken;
  String orderCode;
  String userName;
  String userPhone;
  String documentId;
  String loungeId;
  double longitude;
  double latitude;
  double loungeLongitude;
  double loungeLatitude;

  double distance;
  String loungeOrderNumber;
  bool isPaid;

  Orders(
      {this.food,
      this.information,
      this.price,
      this.quantity,
      this.loungeName,
      this.created,
      this.isTaken,
      this.orderCode,
      this.userName,
      this.userPhone,
      this.documentId,
      this.loungeId,
      this.latitude,
      this.longitude,
      this.deliveryFee,
      this.distance,
      this.loungeOrderNumber,
      this.tip,
      this.loungeLatitude,
      this.loungeLongitude,
      this.isPaid,
      this.serviceCharge,
      this.subTotal});
}

class Cart3Items {
  String foodNameL;
  double foodPriceL;
  int foodQuantityL;
  Cart3Items({this.foodNameL, this.foodPriceL, this.foodQuantityL});
}

class Menu with ChangeNotifier {
  String name;
  String id;
  String images;
  String category;
  double price;

  Menu({this.name, this.images, this.id, this.category, this.price});
}

class UserAuth {
  final String uid;
  UserAuth({this.uid});
}

class UserInfo {
  String userName;
  String userPhone;
  String userPic;
  String userUid;
  String userSex;
  String documentId;
  bool verified;
  bool taker;
  UserInfo({
    this.userName,
    this.userPhone,
    this.userPic,
    this.userUid,
    this.documentId,
    this.verified,
    this.userSex,
    this.taker,
  });
}

class Adress {
  String userUid;
  double longitude;
  double latitude;
  String information;
  String name;
  String documentId;
  Adress(
      {this.information,
      this.latitude,
      this.longitude,
      this.userUid,
      this.name,
      this.documentId});
}

class ConfirmOrder {
  String userUid;

  ConfirmOrder({
    this.userUid,
  });
}
