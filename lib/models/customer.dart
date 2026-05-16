class Customer {
  final String id;
  final String name;
  final String phone;
  final String? address;
  final DateTime createdAt;
  
  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.address,
    required this.createdAt,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
