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

  Future<Stream<QuerySnapshot>> getAllUser() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }

  Future addUserTransaction(
    Map<String, dynamic> userOrderMap,
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Transactions")
        .add(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUsertransaction(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Transactions")
        .snapshots();
  }

  // In your DatabaseMethods class
  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> search(String searchTerm) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Foods")
          .where("search_key", arrayContains: searchTerm.toLowerCase())
          .get();
    } catch (e) {
      print("Search error: $e");
      return await FirebaseFirestore.instance
          .collection("Foods")
          .where("name", isEqualTo: "___no_results___")
          .get();
    }
  }

  Future<QuerySnapshot> searchByName(String searchTerm) async {
    try {
      String searchKey =
          searchTerm.substring(0, 1).toUpperCase() +
          (searchTerm.length > 1 ? searchTerm.substring(1).toLowerCase() : "");

      return await FirebaseFirestore.instance
          .collection("Foods")
          .where("name", isGreaterThanOrEqualTo: searchKey)
          .where("name", isLessThanOrEqualTo: '$searchKey\uf8ff')
          .get();
    } catch (e) {
      print("Search error: $e");
      return await FirebaseFirestore.instance
          .collection("Foods")
          .where("name", isEqualTo: "___no_results___")
          .get();
    }
  }
}
