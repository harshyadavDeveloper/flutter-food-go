import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("orders")
        .doc(orderId)
        .set(userOrderMap);
  }

  Future addAdminOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderId)
        .set(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUserOrder(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('orders')
        .snapshots();
  }

  Future<QuerySnapshot> getUserWalletByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Email", isEqualTo: email)
        .get();
  }

  Future updateWallet(String amount, String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).update({
      "Wallet": amount,
    });
  }

  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Future updateAdminOrder(String id) async {
    return await FirebaseFirestore.instance.collection("Orders").doc(id).update(
      {"Status": "Delievered"},
    );
  }

  Future updateUserOrder(String userid, String docid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .collection("orders")
        .doc(docid)
        .update({"Status": "Delievered"});
  }
}
