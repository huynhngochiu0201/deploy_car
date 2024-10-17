import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_app/models/cart_model.dart';
import 'package:car_app/resources/define_collection.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's id
  String get userId => _auth.currentUser!.uid;

  Future<String> addToCart(CartModel cartModel) async {
    String res = "Some error occurred";
    try {
      // Truy vấn để kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER)
          .doc(cartModel.userId)
          .collection('cart')
          .where('productId', isEqualTo: cartModel.productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Nếu sản phẩm đã tồn tại, tăng số lượng
        DocumentReference docRef = snapshot.docs.first.reference;
        int currentQuantity = snapshot.docs.first.get('quantity') ?? 1;
        await docRef.update({'quantity': currentQuantity + cartModel.quantity});
        res = "Product quantity updated in cart";
      } else {
        // Nếu chưa tồn tại, thêm mới
        await _firestore
            .collection(AppDefineCollection.APP_USER)
            .doc(cartModel.userId)
            .collection(AppDefineCollection.APP_CART)
            .add(cartModel.toJson());
        res = "Product added to cart";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Stream<List<CartModel>> getCartStream() {
    return _firestore
        .collection(AppDefineCollection.APP_USER)
        .doc(userId)
        .collection(AppDefineCollection.APP_CART)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartModel.fromJson(doc.data()))
            .toList());
  }

  // Remove a product from the user's cart by productId
  Future<String> removeFromCart(String productId) async {
    String res = "Some error occurred";
    try {
      // Get the cart items for the user
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER)
          .doc(userId)
          .collection(AppDefineCollection.APP_CART)
          .where('productId', isEqualTo: productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Delete the first matching product (there should be only one)
        await snapshot.docs.first.reference.delete();
        res = "Product removed from cart";
      } else {
        res = "Product not found in cart";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Clear the entire cart for the current user
  Future<void> clearCart() async {
    try {
      // Get all cart products for the user
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER)
          .doc(userId)
          .collection(AppDefineCollection.APP_CART)
          .get();

      // Delete all items in the user's cart
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER)
          .doc(userId)
          .collection(AppDefineCollection.APP_CART)
          .where('productId', isEqualTo: productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference docRef = snapshot.docs.first.reference;
        await docRef.update({'quantity': newQuantity});
      }
    } catch (e) {
      throw Exception('Failed to update quantity: ${e.toString()}');
    }
  }
}
