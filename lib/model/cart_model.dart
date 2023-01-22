class CartModel {
  final Map<String, dynamic> cart;

  CartModel({required this.cart});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(cart: json['cart']);
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart,
    };
  }
}
