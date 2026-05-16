import 'package:uuid/uuid.dart';

const uuid = Uuid();

String generateId() {
  return uuid.v4();
}

String formatCurrency(double amount) {
  return '₹${amount.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatDateTime(DateTime dateTime) {
  return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
