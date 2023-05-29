import 'package:api_1/budget_repository.dart';
import 'package:api_1/failure_model.dart';
import 'package:api_1/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final budgetFutureProvider = FutureProvider.autoDispose((ref) async {
  final budgetRepo = ref.watch(budgetRepoProvider);
  final budget = await budgetRepo.getItems();
  return budget;
});

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
      ),
      body: ref.watch(budgetFutureProvider).when(
        data: (items) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(budgetFutureProvider.future),
            child: ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SpendingChart(
                      items: items,
                    );
                  }
                  final budget = items[index - 1];
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: getCategoryColor(budget.category),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(budget.name),
                      subtitle: Text(
                        '${budget.category} - ${DateFormat.yMd().format(budget.date)}',
                      ),
                      trailing: Text(
                        '-\$${budget.price.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                }),
          );
        },
        error: (error, _) {
          if (error is Failure) {
            return FailureScreen(
              message: error.toString(),
            );
          }
          return const FailureScreen(
            message: 'Something went wrong on our end',
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
