class CheckOutModel {
  final String name;
  final String qty;
  final String qtyMeasure;
  final String salePrice;
  final int count;
  final String image;
  final String date;
  final String time;

  CheckOutModel(
      {required this.name,
      required this.qty,
      required this.qtyMeasure,
      required this.salePrice,
      required this.count,
      required this.image,
      required this.date,
      required this.time});

  factory CheckOutModel.fromJson(Map<String, dynamic> json) {
    return CheckOutModel(
      name: json['name'],
      qty: json['qty'],
      qtyMeasure: json['qtyMeasure'],
      salePrice: json['salePrice'],
      count: json['count'],
      image: json['image'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'qtyMeasure': qtyMeasure,
      'salePrice': salePrice,
      'count': count,
      'image': image,
      'time': time,
      'date': date,
    };
  }
}
