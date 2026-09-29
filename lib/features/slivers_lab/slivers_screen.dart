import 'package:flutter/material.dart';
import '../../core/core.dart';

/// 🌊 مختبر الـ Slivers وهندسة التمرير المتقدمة ومفتش الـ Geometry
class SliversScreen extends StatefulWidget {
  const SliversScreen({super.key});

  @override
  State<SliversScreen> createState() => _SliversScreenState();
}

class _SliversScreenState extends State<SliversScreen> {
  final ScrollController _scrollController = ScrollController();
  double _currentOffset = 0.0;
  bool _isGrid = false;
  bool _isPinned = true;
  bool _isFloating = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _currentOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 1. SliverAppBar تفاعلي
              SliverAppBar(
                expandedHeight: 180,
                pinned: _isPinned,
                floating: _isFloating,
                backgroundColor: const Color(0xFF1E293B),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('مختبر Slivers المتقدم', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF1E293B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.view_quilt_rounded, color: Colors.white24, size: 70),
                    ),
                  ),
                ),
              ),

              // 2. بطاقة الشرح والتحكم
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildExplanationCard(),
                      14.heightBox,
                      _buildControlCard(),
                      14.heightBox,
                      _buildCodeCard(),
                      14.heightBox,
                      const Text(
                        '📜 محتوى القائمة القابل للتمرير (مرر لترى تغير مؤشرات الـ HUD في الأسفل):',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. SliverPersistentHeader لاصق (Sticky Header)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyCategoryHeaderDelegate(title: '⚡ المنتجات المختارة (Sticky Category)'),
              ),

              // 4. القائمة أو الشبكة التفاعلية
              if (_isGrid)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildItemTile(index),
                      childCount: 16,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.builder(
                    itemCount: 16,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildItemTile(index),
                    ),
                  ),
                ),
            ],
          ),

          // 5. لوحة المفتش البصري الحية (Live Scroll & Geometry HUD)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildGeometryHud(),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers_outlined, color: Color(0xFF0D9488), size: 22),
              8.widthBox,
              const Text(
                'كيف تحل Slivers مشاكل التمرير المعقدة؟',
                style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'تتيح لك Slivers دمج App Bar مطاطي، قوائم عادية، شبكات Grids، وعناوين لاصقة (Sticky Headers) في مسار تمرير واحد موحد بدون أي مشاكل تعارض أو بطء.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚙️ خيارات تحكم الـ Slivers:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5)),
          8.heightBox,
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: const Text('Pinned App Bar'),
                  selected: _isPinned,
                  selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.25),
                  onSelected: (val) => setState(() => _isPinned = val),
                ),
              ),
              8.widthBox,
              Expanded(
                child: FilterChip(
                  label: const Text('Floating App Bar'),
                  selected: _isFloating,
                  selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.25),
                  onSelected: (val) => setState(() => _isFloating = val),
                ),
              ),
              8.widthBox,
              Expanded(
                child: FilterChip(
                  label: Text(_isGrid ? 'Grid Mode' : 'List Mode'),
                  selected: _isGrid,
                  selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.25),
                  onSelected: (val) => setState(() => _isGrid = val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('#${index + 1}', style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          10.widthBox,
          Expanded(
            child: Text(
              'عنصر Sliver رقم ${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeometryHud() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF020617).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0D9488), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SCROLL OFFSET', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
                Text('${_currentOffset.toStringAsFixed(1)} px', style: const TextStyle(color: Color(0xFF5EEAD4), fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('VIEWPORT', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
                Text(_isGrid ? 'SliverGrid' : 'SliverList', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SLIVER STATE', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold)),
                Text(_isPinned ? 'PINNED' : 'SCROLLED', style: TextStyle(color: _isPinned ? Colors.greenAccent : Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard() {
    const code =
        'CustomScrollView(\n'
        '  slivers: [\n'
        '    SliverAppBar(expandedHeight: 180, pinned: true),\n'
        '    SliverPersistentHeader(pinned: true, delegate: MyHeaderDelegate()),\n'
        '    SliverList.builder(itemCount: 50, itemBuilder: (ctx, i) => ItemTile(i)),\n'
        '  ],\n'
        ');';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💻 كود معمارية الـ CustomScrollView:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5)),
          8.heightBox,
          const CopyableCodeBlock(code: code, copiedMessage: 'تم نسخ كود Slivers', copyTooltip: 'نسخ الكود'),
        ],
      ),
    );
  }
}

class _StickyCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  _StickyCategoryHeaderDelegate({required this.title});

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFF5EEAD4), fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCategoryHeaderDelegate oldDelegate) => oldDelegate.title != title;
}
