import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_app/core/widgets/beta_avatar.dart';

enum NotificationType { groupInvite, matchResultWin, info }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;
  final bool unread;
  final String? avatarPath;
  final String? name;
  final int? points;

  NotificationItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
    this.avatarPath,
    this.name,
    this.points,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  static const Color kBackground = Color(0xFF000000);
  static const Color kSurface = Color(0xFF121212);
  static const Color kHighlight = Color(0xFF1c1c1c);
  static const Color kAccent = Color(0xFF0df259);
  static const Color kBody = Color(0xFF9ca3af);

  late AnimationController _pulseController;
  int _selectedTab = 0; // 0: All, 1: Unread, 2: System

  final List<NotificationItem> _allNotifications = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);

    _seedDummyData();
  }

  void _seedDummyData() {
    final now = DateTime.now();
    _allNotifications.addAll([
      NotificationItem(
        type: NotificationType.groupInvite,
        title: 'Striker99 seni gruba davet etti',
        body: '"Tahminciler" grubuna katılman için davet gönderdi.',
        time: now.subtract(const Duration(minutes: 25)),
        unread: true,
        avatarPath: 'assets/images/team_logos/user1.png',
        name: 'Striker99',
      ),
      NotificationItem(
        type: NotificationType.matchResultWin,
        title: 'Tahmin Tuttu!',
        body: 'Galatasaray 2-1 Fenerbahçe • +15 Puan kazandın',
        time: now.subtract(const Duration(hours: 3)),
        unread: true,
        points: 15,
      ),
      NotificationItem(
        type: NotificationType.info,
        title: 'Ali tahminini beğendi',
        body: 'Ali senin Galatasaray tahminini beğendi.',
        time: now.subtract(const Duration(days: 1, hours: 2)),
        unread: false,
      ),
      NotificationItem(
        type: NotificationType.info,
        title: 'Sistem güncellemesi',
        body: 'Küçük bakım çalışması planlandı. 02:00 - 03:00 arası.',
        time: now.subtract(const Duration(days: 1, hours: 5)),
        unread: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    setState(() {
      for (var n in _allNotifications) {
        // can't change final fields; recreate list
      }
      final copy = _allNotifications.map((n) => NotificationItem(
            type: n.type,
            title: n.title,
            body: n.body,
            time: n.time,
            unread: false,
            avatarPath: n.avatarPath,
            name: n.name,
            points: n.points,
          )).toList();
      _allNotifications.clear();
      _allNotifications.addAll(copy);
    });
  }

  List<NotificationItem> get _filtered {
    if (_selectedTab == 0) return _allNotifications;
    if (_selectedTab == 1) return _allNotifications.where((n) => n.unread).toList();
    return _allNotifications.where((n) => n.type == NotificationType.info).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _AppBarDelegate(
                minHeight: 64,
                maxHeight: 64,
                child: _buildAppBar(context),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _AppBarDelegate(
                minHeight: 62,
                maxHeight: 62,
                child: _buildTabs(context),
              ),
            ),

            // List grouped by date
            SliverList(
              delegate: SliverChildListDelegate(_buildGroupedList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            border: const Border(bottom: BorderSide(color: Color(0x22FFFFFF), width: 0.5)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: Text('Bildirimler', style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                ),
              ),
              IconButton(
                onPressed: _markAllRead,
                icon: const Icon(Icons.done_all_rounded, color: Colors.white),
                tooltip: 'Mark All Read',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          _buildTab(0, 'Tümü'),
          const SizedBox(width: 8),
          _buildTab(1, 'Okunmayan', showPulse: true),
          const SizedBox(width: 8),
          _buildTab(2, 'Sistem'),
        ],
      ),
    );
  }

  Widget _buildTab(int idx, String label, {bool showPulse = false}) {
    final selected = _selectedTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = idx),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? kAccent : kHighlight,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showPulse) ...[
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) {
                    final scale = 0.9 + 0.15 * _pulseController.value;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: kAccent,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: kAccent.withOpacity(0.4), blurRadius: 8 * _pulseController.value, spreadRadius: 1)],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    color: selected ? Colors.black : kBody,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedList() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = _filtered.where((n) => n.time.day == today.day && n.time.month == today.month && n.time.year == today.year).toList();
    final yesterdayItems = _filtered.where((n) => n.time.day == yesterday.day && n.time.month == yesterday.month && n.time.year == yesterday.year).toList();

    final List<Widget> out = [];
    if (todayItems.isNotEmpty) {
      out.add(_sectionHeader('BUGÜN'));
      out.addAll(todayItems.map(_buildCardFor).toList());
    }
    if (yesterdayItems.isNotEmpty) {
      out.add(_sectionHeader('DÜN'));
      out.addAll(yesterdayItems.map(_buildCardFor).toList());
    }
    // older
    final older = _filtered.where((n) => n.time.isBefore(yesterday)).toList();
    if (older.isNotEmpty) {
      out.add(_sectionHeader('ÖNCEKİ'));
      out.addAll(older.map(_buildCardFor).toList());
    }

    out.add(const SizedBox(height: 140));
    return out;
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(text, style: GoogleFonts.lexend(color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }

  Widget _buildCardFor(NotificationItem n) {
    switch (n.type) {
      case NotificationType.groupInvite:
        return _buildGroupInviteCard(n);
      case NotificationType.matchResultWin:
        return _buildMatchResultCard(n);
      case NotificationType.info:
      default:
        return _buildInfoCard(n);
    }
  }

  Widget _buildGroupInviteCard(NotificationItem n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kAccent.withOpacity(0.9), width: 1),
          boxShadow: [BoxShadow(color: kAccent.withOpacity(0.06), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                BetaAvatar(imagePath: n.avatarPath ?? '', name: n.name ?? 'U', size: 48, borderWidth: 0),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(n.body, style: GoogleFonts.lexend(color: kBody, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(_timeAgo(n.time), style: GoogleFonts.lexend(color: kBody, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('KATIL', style: GoogleFonts.lexend(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.12)),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('REDDET', style: GoogleFonts.lexend(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchResultCard(NotificationItem n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.yellow[700], shape: BoxShape.circle),
              child: const Icon(Icons.emoji_events, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title, style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(n.body, style: GoogleFonts.lexend(color: kBody, fontSize: 13)),
                ],
              ),
            ),
            if (n.points != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(8)),
                child: Text('+${n.points} P', style: GoogleFonts.lexend(color: Colors.black, fontWeight: FontWeight.w800)),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(NotificationItem n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white12, shape: BoxShape.circle), child: const Icon(Icons.info_outline, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title, style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(n.body, style: GoogleFonts.lexend(color: kBody, fontSize: 13)),
              ]),
            ),
            Text(_timeAgo(n.time), style: GoogleFonts.lexend(color: kBody, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk';
    if (diff.inHours < 24) return '${diff.inHours} s';
    return '${diff.inDays} gün';
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  const _AppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _AppBarDelegate oldDelegate) => oldDelegate.maxHeight != maxHeight || oldDelegate.minHeight != minHeight || oldDelegate.child != child;
}
