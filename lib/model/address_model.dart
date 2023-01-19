class AddressModel {
  final String house;
  final String street;
  final String pin;
  final String city;
  final String state;

  AddressModel({
    required this.house,
    required this.street,
    required this.pin,
    required this.city,
    required this.state,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      house: json['house'],
      street: json['street'],
      pin: json['pin'],
      city: json['city'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house': house,
      'street': street,
      'pin': pin,
      'city': city,
      'state': state,
    };
  }
}
