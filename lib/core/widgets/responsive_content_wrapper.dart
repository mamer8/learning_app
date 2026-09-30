import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// 📐 حاوية متجاوبة تضمن توسيط المحتوى وحد أقصى للأبعاد على شاشات الويب والديسكتوب
class ResponsiveContentWrapper extends StatelessWidget {
  const ResponsiveContentWrapper({
    required this.child,
    super.key,
    this.maxWidth = 1200,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final horizontalPad = context.isDesktop
        ? 32.0
        : context.isTablet
            ? 24.0
            : 16.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: horizontalPad),
          child: child,
        ),
      ),
    );
  }
}

/// 🔀 عرض منقسم متجاوب (Side-by-Side Split View على الويب وعمودي على الموبايل)
class AdaptiveSplitView extends StatelessWidget {
  const AdaptiveSplitView({
    required this.primary,
    required this.secondary,
    super.key,
    this.breakpoint = 920,
    this.primaryFlex = 5,
    this.secondaryFlex = 5,
    this.spacing = 20,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final int primaryFlex;
  final int secondaryFlex;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: primaryFlex,
                child: primary,
              ),
              SizedBox(width: spacing),
              Expanded(
                flex: secondaryFlex,
                child: secondary,
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primary,
              SizedBox(height: spacing),
              secondary,
            ],
          );
        }
      },
    );
  }
}

/// 🧱 شبكة متجاوبة توزع العناصر في أعمدة بحسب عرض الشاشة (1 للموبايل، 2 للتابلت، 3 للديسكتوب/الويب)
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 14,
    this.runSpacing = 14,
    this.childAspectRatio,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? desktopColumns
            : width >= 640
                ? tabletColumns
                : mobileColumns;

        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: runSpacing),
                children[i],
              ],
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            mainAxisExtent: childAspectRatio == null ? null : null,
            childAspectRatio: childAspectRatio ?? (columns == 2 ? 2.4 : 2.1),
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
