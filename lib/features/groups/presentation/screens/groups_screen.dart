import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/group_detail_screen.dart';
import '../../../home/data/dummy_data.dart';
import 'package:world_cup_app/features/notifications/presentation/screens/notifications_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  // Dummy data for groups
  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Ofis Ligi',
      'rank': 3,
      'week': 12,
      'members': 24,
      'image': 'https://picsum.photos/200/200?random=1',
      'isLeader': false,
    },
    {
      'name': 'Lise Arkadaşları',
      'rank': 1,
      'week': 15,
      'members': 18,
      'image': 'https://picsum.photos/200/200?random=2',
      'isLeader': true,
    },
    {
      'name': 'Futbol Tutkunları',
      'rank': 7,
      'week': 10,
      'members': 32,
      'image': 'https://picsum.photos/200/200?random=3',
      'isLeader': false,
    },
    {
      'name': 'Aile Ligi',
      'rank': 2,
      'week': 18,
      'members': 12,
      'image': 'https://picsum.photos/200/200?random=4',
      'isLeader': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Action Buttons
                  _buildActionButtons(),

                  const SizedBox(height: 32),

                  // Section Title
                  _buildSectionTitle(),

                  const SizedBox(height: 16),

                  // Group Cards
                  ..._groups.map((group) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GroupCard(
                          name: group['name'],
                          rank: group['rank'],
                          week: group['week'],
                          members: group['members'],
                          imageUrl: group['image'],
                          isLeader: group['isLeader'],
                          onEnter: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GroupDetailScreen(groupName: group['name']),
                              ),
                            );
                          },
                        ),
                      )),

                  const SizedBox(height: 24),

                  // Invite Banner
                  _buildInviteBanner(),

                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.background,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              'Gruplarım',
              style: GoogleFonts.lexend(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Notification Icon
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  // Notification Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cardSurface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons Widget
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Grup Oluştur Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle create group
                print('Create Group tapped');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: AppColors.background,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Grup Oluştur',
                      style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Gruba Katıl Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle join group
                print('Join Group tapped');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_add,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gruba Katıl',
                      style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Aktif Ligler',
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle see all
              print('See all tapped');
            },
            child: Text(
              'Tümünü Gör',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Invite Banner Widget
  Widget _buildInviteBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Blur circle decoration
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arkadaşlarını Davet Et',
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Daha fazla arkadaş, daha fazla eğlence!',
                            style: GoogleFonts.lexend(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.background.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.background,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Group Card Widget
class GroupCard extends StatelessWidget {
  final String name;
  final int rank;
  final int week;
  final int members;
  final String imageUrl;
  final bool isLeader;
  final VoidCallback onEnter;

  const GroupCard({
    super.key,
    required this.name,
    required this.rank,
    required this.week,
    required this.members,
    required this.imageUrl,
    this.isLeader = false,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Left Content
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges Row
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildBadge(
                              '#$rank. Sıra',
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary,
                            ),
                            _buildBadge(
                              'Hafta $week',
                              const Color(0xFF9ca3af).withOpacity(0.15),
                              const Color(0xFF9ca3af),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Group Name
                        Text(
                          name,
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Members
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: const Color(0xFF9ca3af),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$members üye',
                              style: GoogleFonts.lexend(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF9ca3af),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Enter Button
                        GestureDetector(
                          onTap: onEnter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Giriş Yap',
                                  style: GoogleFonts.lexend(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.textPrimary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right - Group Image
                  Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Placeholder for image
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.2),
                                  AppColors.cardSurface,
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.group,
                              color: AppColors.primary.withOpacity(0.3),
                              size: 48,
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.4),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Leader Badge (Top Right)
            if (isLeader)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700), // Gold
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: AppColors.background,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Lider',
                        style: GoogleFonts.lexend(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.lexend(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
