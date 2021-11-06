import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {
  String menuId;
  String userUid;
  String loungeId;
  Timestamp created;
  String orderNumber;
  String id;
  String userPhoneNumber;
  double latitude;
  double longitude;

  DatabaseService(
      {this.menuId,
      this.userPhoneNumber,
      this.userUid,
      this.id,
      this.created,
      this.orderNumber,
      this.latitude,
      this.longitude,
      this.loungeId});
//collecton reference
  final CollectionReference loungesCollection =
      FirebaseFirestore.instance.collection('Lounges');
  final CollectionReference carrierUsersCollection =
      FirebaseFirestore.instance.collection('Carriers');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Orders');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference adressCollection =
      FirebaseFirestore.instance.collection('Adress');
  final CollectionReference controllerCollection =
      FirebaseFirestore.instance.collection('Controller');

  final geo = Geoflutterfire();

  //******************************************************************************************** */

  List<Controller> _controllerInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Controller(
          version: doc.data()['AndroidAdrashVersion'].toInt() ?? 0,
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<Controller>> get controllerInfo {
    return controllerCollection
        .snapshots()
        .map(_controllerInfoListFromSnapshot);
  }

  //*************************************user related******************************************************* */
  Future newUserData(
    String profilePic,
    String name,
    String userUid,
  ) async {
    carrierUsersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isEmpty) {
        return await carrierUsersCollection.doc(userUid).set({
          'created': Timestamp.now(),
          'profilePic': profilePic,
          'name': name,
          'phoneNumber': userPhoneNumber,
          'userUid': userUid,
          'verified': false,
        });
      }
    });
  }

  Future updateCurrentUser(
    String name,
  ) async {
    return await carrierUsersCollection.doc(userUid).update({
      'name': name,
    });
  }

  Future updateNameandSex(
    String name,
    String sex,
  ) async {
    return await carrierUsersCollection.doc(userUid).update({
      'name': name,
      'sex': sex,
    });
  }

  Future usserInfo() async {
    usersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          return UserInfo(
            userName: docs.docs[i].get('name') ?? '',
            userPhone: docs.docs[i].get('phoneNumber') ?? '',
            userPic: docs.docs[i].get('profilePic') ?? '',
            verified: docs.docs[i].get('verified') ?? false,
          );
        }
      }
    });
  }

  Future newUserMessagingToken(
    String userUid,
    String messagingToken,
  ) async {
    carrierUsersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isNotEmpty) {
        return carrierUsersCollection
            .doc(userUid)
            .update({
              'messagingToken': messagingToken,
            })
            .then((value) => print('checked from data base'))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  List<UserInfo> _userInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserInfo(
          userPic: doc.data()['profilePic'] ?? '',
          userUid: doc.data()['userUid'] ?? '',
          userName: doc.data()['name'] ?? '',
          userSex: doc.data()['sex'] ?? '',
          userPhone: doc.data()['phoneNumber'] ?? '',
          lastPaid: doc.data()['lastPaid'] ?? 0,
          verified: doc.data()['verified'] ?? false,
          taker: doc.data()['taker'] ?? false,
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<UserInfo>> get userInfo {
    return carrierUsersCollection
        .where('userUid', isEqualTo: userUid)
        // .orderBy('created', descending: true)
        .snapshots()
        .map(_userInfoListFromSnapshot);
  }
  //******************************************User related************************************************** */

  Future updateOrderData(
    List foodName,
    List foodPrice,
    List foodQuantity,
    double total,
    String loungeName,
    bool isTaken,
    bool isDelivered,
    String userName,
    String userPhone,
    String userUid,
    String userPic,
    String loungeId,
    double longitude,
    double latitude,
    String information,
    Timestamp created,
    String orderNumber,
    double serviceCharge,
  ) async {
    return await orderCollection.add({
      'food': foodName,
      'price': foodPrice,
      'quantity': foodQuantity,
      'total': total,
      'loungeName': loungeName,
      'created': created,
      'isTaken': isTaken,
      'isDelivered': isDelivered,
      'userName': userName,
      'userPhone': userPhone,
      'userUid': userUid,
      'userPic': userPic,
      'orderCode': orderNumber,
      'loungeId': loungeId,
      'Longitude': longitude,
      'Latitude': latitude,
      'information': information,
      'carrierName': null,
      'carrierphone': null,
      'carrierUserUid': null,
      'serviceCharge': serviceCharge
    });
  }

  List<ConfirmOrder> _confirmOrderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ConfirmOrder(
        userUid: doc.data()['userUid'] ?? '',
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<ConfirmOrder>> get confirmOrder {
    return orderCollection
        .where('userUid', isEqualTo: userUid)
        .where('created', isEqualTo: created)
        .where('orderCode', isEqualTo: orderNumber)
        .snapshots()
        .map(_confirmOrderListFromSnapshot);
  }

  Future updateOrderIsDelivered() async {
    orderCollection.doc(id).update({
      'isDelivered': true,
      'deliveryTime': Timestamp.now(),
    });
  }

  Future updateCarrierLocation(
    double carrierLatitude,
    double carrierLongitude,
  ) async {
    orderCollection.doc(id).update({
      'carrierLatitude': carrierLatitude,
      'carrierLongitude': carrierLongitude,
    });
  }

  Future updateOrderWithCarriers(
    String carrierName,
    String carrierphone,
    String carrierUserUid,
    String carrierUserPic,
    double carrierLatitude,
    double carrierLongitude,
  ) async {
    orderCollection.doc(id).update({
      'carrierName': carrierName,
      'carrierphone': carrierphone,
      'carrierUserUid': carrierUserUid,
      'carrierUserPic': carrierUserPic,
      'isTaken': true,
      'carrierLatitude': carrierLatitude,
      'carrierLongitude': carrierLongitude,
    });
  }

  Future cancelTake() async {
    return orderCollection
        .doc(id)
        .update({'isTaken': false, 'carrierUserUid': ''});
  }
  //******************************************************************************************** */

  //******************************************************************************************** */
// lounge list from a snapshot
  List<Lounges> _loungesListFromSnapshot(List<DocumentSnapshot> snapshot) {
    return snapshot.map((doc) {
      return Lounges(
        name: doc.data()['name'] ?? '',
        images: doc.data()['image'] ?? '',
        id: doc.data()['id'] ?? '',
        longitude: doc.data()['Location']['geopoint'].longitude ?? 0,
        latitude: doc.data()['Location']['geopoint'].latitude ?? 0,
        category: doc.data()['category'] ?? '',
        lounge: doc.data()['lounge'] ?? '',
        active: doc.data()['active'] ?? '',
        weAreOpen: doc.data()['weAreOpen'] ?? '',
        deliveryRadius: doc.data()['deliveryRadius'].toDouble() ?? '',
        needsVerification: doc.data()['needsVerification'] ?? false,
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<Lounges>> get lounges {
    GeoFirePoint myLocation = Geoflutterfire().point(
        latitude: latitude == null ? 0.0 : latitude,
        longitude: longitude == null ? 0.0 : longitude);
    return geo
        .collection(collectionRef: loungesCollection)
        .within(
            center: myLocation,
            radius: 5.0,
            field: 'Location',
            strictMode: true)
        .map(_loungesListFromSnapshot);
    // .map((event) => event.map((doc) {
    //       return Lounges(
    //         name: doc.data()['name'] ?? '',
    //         images: doc.data()['image'] ?? '',
    //         id: doc.data()['id'] ?? '',
    //         longitude: doc.data()['Location'].geopoint.longitude ?? '',
    //         latitude: doc.data()['Location'].geopoint.latitude ?? '',
    //         category: doc.data()['category'] ?? '',
    //         lounge: doc.data()['lounge'] ?? '',
    //         active: doc.data()['active'] ?? '',
    //         weAreOpen: doc.data()['weAreOpen'] ?? '',
    //         documentId: doc.reference.id ?? '',
    //       );
    //     }).toList());

    // loungesCollection.snapshots().map(_loungesListFromSnapshot);
  }
  //******************************************************************************************** */

  //******************************************************************************************** */

  //list of orders(length) at the top of lounge Marker.
  Stream<List<Orders>> get orders {
    return orderCollection
        .where('isTaken', isEqualTo: false)
        .where('isDelivered', isEqualTo: false)
        .where('eatThere', isEqualTo: false)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersListFromSnapshot);
  }

  //list of orders when a lounge is opened
  Stream<List<Orders>> get ordersDetail {
    return orderCollection
        .where('isDelivered', isEqualTo: false)
        .where('isTaken', isEqualTo: false)
        .where('eatThere', isEqualTo: false)
        .where('loungeId', isEqualTo: loungeId)
        .orderBy('created', descending: true)
        .snapshots()
        // .handleError((onError){print(onError.toString());})
        .map(_ordersListFromSnapshot);
  }

  //list of orders when taken orders is tapped. (The list of orders taken by a carrier)
  Stream<List<OrdersCarrier>> get orderCarrier {
    return orderCollection
        .where('isDelivered', isEqualTo: false)
        .where('carrierUserUid', isEqualTo: id)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersCarrierListFromSnapshot);
  }

  Stream<List<Orders>> get completeOrders {
    return orderCollection
        .where('isDelivered', isEqualTo: true)
        .where('isTaken', isEqualTo: true)
        // .where('isPaid', isEqualTo: false)
        .where('carrierUserUid', isEqualTo: userUid)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersListFromSnapshot);
  }

  List<Orders> _ordersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Orders(
          food: doc.data()['food'] ?? '',
          quantity: doc.data()['quantity'] ?? '',
          price: doc.data()['price'] ?? '',
          loungeName: doc.data()['loungeName'] ?? '',
          loungeId: doc.data()['loungeId'] ?? '',
          created: doc.data()['created'] ?? '',
          isTaken: doc.data()['isTaken'] ?? '',
          orderCode: doc.data()['orderCode'] ?? '',
          userName: doc.data()['userName'] ?? '',
          information: doc.data()['information'] ?? '',
          userPhone: doc.data()['userPhone'] ?? '',
          latitude: doc.data()['Latitude'] ?? '',
          longitude: doc.data()['Longitude'] ?? '',
          loungeLatitude:
              doc.data()['LoungeLocation']['geopoint'].latitude ?? 0.0,
          loungeLongitude:
              doc.data()['LoungeLocation']['geopoint'].longitude ?? 0.0,
          distance: doc.data()['distance'].toDouble() ?? 0.0,
          deliveryFee: doc.data()['deliveryFee'].toDouble() ?? 0.0,
          serviceCharge: doc.data()['serviceCharge'].toDouble() ?? 0.0,
          tip: doc.data()['tip'].toInt() ?? 0,
          subTotal: doc.data()['subTotal'] ?? '',
          loungeOrderNumber: doc.data()['loungeOrderNumber'] ?? '',
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  List<OrdersCarrier> _ordersCarrierListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OrdersCarrier(
          food: doc.data()['food'] ?? '',
          quantity: doc.data()['quantity'] ?? '',
          price: doc.data()['price'] ?? '',
          loungeName: doc.data()['loungeName'] ?? '',
          loungeId: doc.data()['loungeId'] ?? '',
          created: doc.data()['created'] ?? '',
          isTaken: doc.data()['isTaken'] ?? '',
          orderCode: doc.data()['orderCode'] ?? '',
          userName: doc.data()['userName'] ?? '',
          information: doc.data()['information'] ?? '',
          userPhone: doc.data()['userPhone'] ?? '',
          latitude: doc.data()['Latitude'] ?? '',
          longitude: doc.data()['Longitude'] ?? '',
          loungeLatitude:
              doc.data()['LoungeLocation']['geopoint'].latitude ?? 0.0,
          loungeLongitude:
              doc.data()['LoungeLocation']['geopoint'].longitude ?? 0.0,
          distance: doc.data()['distance'].toDouble() ?? 0.0,
          deliveryFee: doc.data()['deliveryFee'].toDouble() ?? 0.0,
          serviceCharge: doc.data()['serviceCharge'].toDouble() ?? 0.0,
          tip: doc.data()['tip'].toInt() ?? 0,
          subTotal: doc.data()['subTotal'] ?? '',
          loungeOrderNumber: doc.data()['loungeOrderNumber'] ?? '',
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  Future removeOrder() async {
    return orderCollection.doc(id).delete();
  }
  //******************************************************************************************** */

  //******************************************************************************************** */

  //******************************************************************************************** */

  List<Adress> _adressListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Adress(
        longitude: doc.data()['Longitude'] ?? '',
        latitude: doc.data()['Latitude'] ?? '',
        userUid: doc.data()['userUid'] ?? '',
        name: doc.data()['name'] ?? '',
        information: doc.data()['information'] ?? '',
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<Adress>> get adress {
    return adressCollection
        .where('userUid', isEqualTo: userUid)
        .snapshots()
        .map(_adressListFromSnapshot);
  }

  Future removeAdress() async {
    return adressCollection.doc(id).delete();
  }

  Future addAdress(
    double latitude,
    double longitude,
    String userUid,
    String name,
    String information,
  ) async {
    return await adressCollection.add({
      'created': Timestamp.now(),
      'Latitude': latitude,
      'Longitude': longitude,
      'userUid': userUid,
      'name': name,
      'information': information,
    });
  }
}
