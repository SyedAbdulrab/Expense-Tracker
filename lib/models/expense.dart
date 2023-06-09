import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

final formatter = DateFormat.yMd();
const uuid = Uuid();
enum Category {
  food, travel, leisure, work
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : id = uuid.v4();

  final String title;
  final double amount;
  final String id;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  void saveExpenses(List<Expense> expenses) {
    final file = File('expenses.txt');
    final encodedExpenses = expenses.map((expense) => expense.toJson()).toList();
    final jsonString = jsonEncode(encodedExpenses);
    file.writeAsStringSync(jsonString);
  }

  // Convert Expense object to JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'category': category.toString().split('.').last, // Store category as a string
    'date': date.toString(),
  };

  // Create Expense object from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      title: json['title'] as String,
      amount: json['amount'] as double,
      category: Category.values.firstWhere((category) =>
      category.toString().split('.').last == json['category']),
      date: DateTime.parse(json['date'] as String),
    );
  }

  List<Expense> loadExpenses() {
    try {
      final file = File('expenses.txt');
      if (file.existsSync()) {
        final jsonString = file.readAsStringSync();
        final decodedExpenses = jsonDecode(jsonString) as List<dynamic>;
        return decodedExpenses.map((json) => Expense.fromJson(json)).toList();
      }
    } catch (e) {
      print('Failed to load expenses: $e');
    }
    return [];
  }

  // Adding an expense
  void addExpenseToFile(Expense expense) {
    final expenses = loadExpenses();
    expenses.add(expense);
    saveExpenses(expenses);
  }

  // Removing an expense
  void removeExpenseFromFile(Expense expense) {
    final expenses = loadExpenses();
    expenses.remove(expense);
    saveExpenses(expenses);
  }
}

class ExpenseBucket {
  const ExpenseBucket(this.category, this.expenses);

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
