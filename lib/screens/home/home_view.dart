import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/providers/user_provider.dart';
import 'package:rhino_bond/services/authentication.services.dart';
import 'package:rhino_bond/screens/scanner/scanner_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  List<Map<String, dynamic>> _filterActiveEvents(
      List<Map<String, dynamic>> events) {
    final now = DateTime.now();
    return events.where((event) {
      final endDate = DateTime.tryParse(event['end_date'] ?? '');
      return endDate != null && endDate.isAfter(now);
    }).toList();
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;
    print('Loading events...');

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authService =
        Provider.of<AuthenticationService>(context, listen: false);
    try {
      final events = await authService.getActiveEvents();
      print('Fetched ${events.length} events');
      if (!mounted) return;

      final activeEvents = _filterActiveEvents(events);
      print('Filtered to ${activeEvents.length} active events');

      setState(() {
        _events = activeEvents;
        _isLoading = false;
        print('Events updated in state');
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = "Failed to load events. Please try again later.";
        _events = [];
        _isLoading = false;
      });
    }
  }

  Widget _buildEventCarousel() {
    if (_isLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadEvents,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_events.isEmpty) {
      return const SizedBox(height: 0);
    }

    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _events.length,
              controller: PageController(viewportFraction: 0.95),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final event = _events[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        event['image_url'] != null &&
                                event['image_url'].isNotEmpty
                            ? Image.network(
                                event['image_url']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child:
                                          Icon(Icons.error_outline, size: 40),
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image, size: 40),
                                ),
                              ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title'] ?? 'Untitled Event',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event['description'] ??
                                      'No description available',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_events.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _events.length,
                (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Home',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: CustomAppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadEvents();
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          await userProvider.refreshUserData();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScannerScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Scan your QR Code',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildEventCarousel(),
                  if (_events.isNotEmpty) const SizedBox(height: 32),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final points =
                          userProvider.userData?['points_balance'] ?? 0;
                      return Card(
                        elevation: 4,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        size: 24,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Total Points',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/rewards_history',
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'View History',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$points',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/rewards');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Rewards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
