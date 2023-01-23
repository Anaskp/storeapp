class CartProductModel {
  final String name;
  final String qty;
  final String qtyMeasure;
  final String originalPrice;
  final String salePrice;
  final int count;
  final String image;

  CartProductModel({
    required this.name,
    required this.qty,
    required this.qtyMeasure,
    required this.originalPrice,
    required this.salePrice,
    required this.count,
    required this.image,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      name: json['name'],
      qty: json['qty'],
      qtyMeasure: json['qtyMeasure'],
      originalPrice: json['originalPrice'],
      salePrice: json['salePrice'],
      count: json['count'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'qtyMeasure': qtyMeasure,
      'originalPrice': originalPrice,
      'salePrice': salePrice,
      'count': count,
      'image': image,
    };
  }
}
