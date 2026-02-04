class Address {
  final String id;
  final String label; // Home, Work, etc.
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromMap(Map<String, dynamic> data, String id) {
    return Address(
      id: id,
      label: data['label'] ?? '',
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      zipCode: data['zipCode'] ?? '',
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }
}
