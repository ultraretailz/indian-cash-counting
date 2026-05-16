class Denomination {
  final int value;
  int count;
  
  Denomination({
    required this.value,
    this.count = 0,
  });
  
  double get total => value * count;
  
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'count': count,
    };
  }
  
  factory Denomination.fromMap(Map<String, dynamic> map) {
    return Denomination(
      value: map['value'],
      count: map['count'],
    );
  }
}
