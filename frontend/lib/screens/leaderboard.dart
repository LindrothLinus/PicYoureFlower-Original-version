import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/resources/constants.dart';
import 'package:flutter_demo/screens/view_friend.dart';
import 'package:flutter_demo/widgets/back_btn.dart';
import 'package:flutter_demo/widgets/camera_button.dart';
import 'package:flutter_demo/widgets/friend_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const List<({double x, double y})> _addButtonCoordinates = [
  (x: 3000, y: 1400),
  (x: 2500, y: 1400),
  (x: 3000, y: 2150),
  (x: 2500, y: 2150),
  (x: 3000, y: 2850),
  (x: 2500, y: 2850),
  (x: 2000, y: 2850),
  (x: 3500, y: 2850),
  (x: 4000, y: 2850),
  (x: 1500, y: 2850),
];

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardEntry {
  final int id;
  final String name;
  final String profilePicture;
  final int flowerCount;
  final int likes;

  _LeaderboardEntry({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.flowerCount,
    required this.likes,
  });
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<_LeaderboardEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        http.get(Uri.parse('${UrlConst.userService}/home/leaderboard')),
        http.get(Uri.parse('${UrlConst.flowerService}/home/all')),
      ]);

      if (!mounted) return;

      final usersRes = results[0];
      final flowersRes = results[1];

      if (usersRes.statusCode == 200 && flowersRes.statusCode == 200) {
        final List<dynamic> users = jsonDecode(usersRes.body);
        final List<dynamic> flowers = jsonDecode(flowersRes.body);

        final Map<int, int> flowerCounts = {};
        for (final flower in flowers) {
          final int? userId = (flower['userId'] as num?)?.toInt();
          if (userId != null) {
            flowerCounts[userId] = (flowerCounts[userId] ?? 0) + 1;
          }
        }

        final entries = users.map((user) {
          final int id = (user['id'] as num).toInt();
          return _LeaderboardEntry(
            id: id,
            name: (user['name'] as String?) ?? 'Unknown',
            profilePicture: (user['profilePicture'] as String?) ?? 'Avatar_Green',
            flowerCount: flowerCounts[id] ?? 0,
            likes: (user['likes'] as num?)?.toInt() ?? 0,
          );
        }).toList();

        entries.sort((a, b) => b.flowerCount.compareTo(a.flowerCount));

        setState(() {
          _entries = entries;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading leaderboard: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.white;
  }

  void _openGreenhouse(_LeaderboardEntry entry) {
    final friend = Friend(
      entry.name,
      entry.id,
      profilePicture: entry.profilePicture,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFriendScreen(
          userId: loggedInUserId,
          friend: friend,
          addButtonsCordinats: _addButtonCoordinates,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collectors', style: TextStyles.header),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: CustomBackButton(toHome: false),
      ),
      backgroundColor: backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLeaderboard,
              child: _entries.isEmpty
                  ? Center(
                      child: Text('No players yet!', style: TextStyles.infoText),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        final rank = index + 1;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _openGreenhouse(entry),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: _rankColor(rank),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black26, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$rank',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Image.asset(
                                    'lib/resources/images/${entry.profilePicture}.png',
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'lib/resources/images/Avatar_Green.png',
                                      width: 56,
                                      height: 56,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.name,
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'lib/resources/images/flower_icon.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${entry.flowerCount}',
                                              style: TextStyles.infoText),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'lib/resources/images/Like.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${entry.likes}',
                                              style: TextStyles.infoText),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}