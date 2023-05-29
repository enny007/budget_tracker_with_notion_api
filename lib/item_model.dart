// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  final String name;
  final String category;
  final double price;
  final DateTime date;
  Item({
    required this.name,
    required this.category,
    required this.price,
    required this.date,
  });

  Item copyWith({
    String? name,
    String? category,
    double? price,
    DateTime? date,
  }) {
    return Item(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'category': category,
      'price': price,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = properties['Date']?['date']?['start'];
    return Item(
      name: properties['Name']?['title']?[0]?['plain_text'] ?? '?',
      category: properties['Categories']?['select']?['name'] ?? 'Any',
      price: properties['Price']?['number'] ?? 0,
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(name: $name, category: $category, price: $price, date: $date)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.category == category &&
        other.price == price &&
        other.date == date;
  }

  @override
  int get hashCode {
    return name.hashCode ^ category.hashCode ^ price.hashCode ^ date.hashCode;
  }
}
