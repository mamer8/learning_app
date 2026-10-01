import 'package:flutter/material.dart';

enum TestCategory {
  unit,
  bloc,
  mocking,
  widget,
}

enum TestStatus {
  idle,
  running,
  passed,
  failed,
}

class TestAssertion {
  final String title;
  final String expected;
  final String actual;
  final bool isPassed;

  const TestAssertion({
    required this.title,
    required this.expected,
    required this.actual,
    required this.isPassed,
  });
}

class TestCaseItem {
  final String id;
  final TestCategory category;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final String targetComponent;
  final String codeSnippet;
  final List<String> stepsAr;
  final List<String> stepsEn;
  final List<TestAssertion> assertions;

  const TestCaseItem({
    required this.id,
    required this.category,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.targetComponent,
    required this.codeSnippet,
    required this.stepsAr,
    required this.stepsEn,
    required this.assertions,
  });
}
