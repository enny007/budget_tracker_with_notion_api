import 'package:api_1/home_page.dart';
import 'package:api_1/item_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({
    super.key,
    required this.items,
  });

  final List<Item> items;
  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};
    for (final item in items) {
      spending.update(
        item.category,
        (value) {
          return value + item.price;
        },
        ifAbsent: () => item.price,
      );
    }
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 360,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: spending
                      .map((category, amountSpent) => MapEntry(
                            category,
                            PieChartSectionData(
                                color: getCategoryColor(category),
                                radius: 100,
                                title: '\$${amountSpent.toStringAsFixed(2)}',
                                value: amountSpent),
                          ))
                      .values
                      .toList(),
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: spending.keys
                  .map(
                    (category) => Indicator(
                      color: getCategoryColor(category),
                      text: category,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          color: color,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
