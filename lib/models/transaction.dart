class Transaction {
  final String id;
  final String customerId;
  final double cashAmount;
  final double onlineAmount;
  final double otherAmount;
  final String description;
  final String itemsSold;
  final DateTime transactionDate;
  
  Transaction({
    required this.id,
    required this.customerId,
    required this.cashAmount,
    required this.onlineAmount,
    required this.otherAmount,
    required this.description,
    required this.itemsSold,
    required this.transactionDate,
  });
  
  double get totalAmount => cashAmount + onlineAmount + otherAmount;
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'cashAmount': cashAmount,
      'onlineAmount': onlineAmount,
      'otherAmount': otherAmount,
      'description': description,
      'itemsSold': itemsSold,
      'transactionDate': transactionDate.toIso8601String(),
    };
  }
  
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      customerId: map['customerId'],
      cashAmount: map['cashAmount'].toDouble(),
      onlineAmount: map['onlineAmount'].toDouble(),
      otherAmount: map['otherAmount'].toDouble(),
      description: map['description'],
      itemsSold: map['itemsSold'],
      transactionDate: DateTime.parse(map['transactionDate']),
    );
  }
}
