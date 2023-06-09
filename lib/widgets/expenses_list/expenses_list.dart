import 'package:expense_tracker/widgets/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget{
  const ExpensesList({super.key,required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length, // item builder will build items upto index == itemCount
        itemBuilder: (ctx,index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(.75),
              ),
          key: ValueKey(expenses[index]),
            onDismissed: (direction){
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expenses[index])),);
  }
  
}