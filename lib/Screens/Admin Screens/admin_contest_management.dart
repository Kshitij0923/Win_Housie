import 'package:flutter/material.dart';
import 'package:tambola/Provider/Modal/contest.dart';
import 'package:tambola/Provider/Modal/sontest_service.dart';
import 'package:tambola/Screens/Admin%20Screens/admin_number_caller.dart';
import 'package:tambola/Theme/app_theme.dart';

class ContestManagementScreen extends StatefulWidget {
  final ContestService contestService;
  const ContestManagementScreen({Key? key, required this.contestService})
    : super(key: key);

  @override
  State<ContestManagementScreen> createState() =>
      _ContestManagementScreenState();
}

class _ContestManagementScreenState extends State<ContestManagementScreen> {
  List<Contest> _contests = [];
  bool _isLoading = true;
  String _filterOption = 'All';

  @override
  void initState() {
    super.initState();
    _loadContests();
    widget.contestService.contestsStream.listen((contests) {
      setState(() {
        _contests = contests;
      });
    });
  }

  Future<void> _loadContests() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final contests = widget.contestService.getContests();
      setState(() {
        _contests = contests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading contests: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Contest> get _filteredContests {
    switch (_filterOption) {
      case 'Active':
        return _contests.where((contest) => contest.isActive).toList();
      case 'Upcoming':
        return _contests
            .where(
              (contest) =>
                  contest.startTime.isAfter(DateTime.now()) &&
                  !contest.isActive,
            )
            .toList();
      case 'Past':
        return _contests
            .where((contest) => contest.endTime.isBefore(DateTime.now()))
            .toList();
      default:
        return _contests;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);
    return Scaffold(
      body: Column(
        children: [
          _buildFilterOptions(theme),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredContests.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildContestList(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(AppTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.hp(1),
        horizontal: theme.wp(4),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final option in ['All', 'Active', 'Upcoming', 'Past'])
              Padding(
                padding: EdgeInsets.only(right: theme.wp(2)),
                child: ChoiceChip(
                  label: Text(option),
                  selected: _filterOption == option,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _filterOption = option;
                      });
                    }
                  },
                  selectedColor: theme.primaryColor,
                  labelStyle: TextStyle(
                    color:
                        _filterOption == option
                            ? Colors.white
                            : theme.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: theme.wp(20),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: theme.hp(2)),
          Text(
            'No contests found',
            style: TextStyle(
              fontSize: theme.sp(5),
              fontWeight: FontWeight.bold,
              color: theme.textPrimaryColor,
            ),
          ),
          SizedBox(height: theme.hp(1)),
          Text(
            _filterOption == 'All'
                ? 'There are no contests available'
                : 'No $_filterOption contests available',
            style: TextStyle(
              fontSize: theme.sp(4),
              color: theme.textSecondaryColor,
            ),
          ),
          SizedBox(height: theme.hp(3)),
          ElevatedButton.icon(
            onPressed: _loadContests,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: theme.wp(6),
                vertical: theme.hp(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestList(AppTheme theme) {
    return RefreshIndicator(
      onRefresh: _loadContests,
      child: ListView.builder(
        padding: EdgeInsets.all(theme.wp(4)),
        itemCount: _filteredContests.length,
        itemBuilder: (context, index) {
          final contest = _filteredContests[index];
          return _buildContestCard(theme, contest);
        },
      ),
    );
  }

  Widget _buildContestCard(AppTheme theme, Contest contest) {
    final bool isActive = contest.isActive;
    final bool isPast = contest.endTime.isBefore(DateTime.now());
    final bool isUpcoming =
        contest.startTime.isAfter(DateTime.now()) && !isActive;
    Color statusColor;
    String statusText;
    if (isPast) {
      statusColor = Colors.grey;
      statusText = 'Completed';
    } else if (isActive) {
      statusColor = Colors.green;
      statusText = 'Active';
    } else if (isUpcoming) {
      statusColor = Colors.orange;
      statusText = 'Upcoming';
    } else {
      statusColor = Colors.blue;
      statusText = 'Scheduled';
    }
    return Card(
      margin: EdgeInsets.only(bottom: theme.hp(2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isActive
                  ? theme.primaryColor.withOpacity(0.5)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(theme.wp(4)),
            title: Text(
              contest.title,
              style: TextStyle(
                fontSize: theme.sp(5),
                fontWeight: FontWeight.bold,
                color: theme.textPrimaryColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: theme.hp(1)),
                Text(
                  contest.description,
                  style: TextStyle(
                    fontSize: theme.sp(3.5),
                    color: theme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: theme.hp(1)),
                // Fixed date display row
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: theme.sp(4),
                      color: theme.textSecondaryColor,
                    ),
                    SizedBox(width: theme.wp(1)),
                    Text(
                      '${_formatDate(contest.startTime)} - ${_formatDate(contest.endTime)}',
                      style: TextStyle(
                        fontSize: theme.sp(3.5),
                        color: theme.textSecondaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: theme.hp(0.5)),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: theme.sp(4),
                      color: theme.textSecondaryColor,
                    ),
                    SizedBox(width: theme.wp(1)),
                    Text(
                      '${contest.participantsCount} participants',
                      style: TextStyle(
                        fontSize: theme.sp(3.5),
                        color: theme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.wp(3),
                vertical: theme.hp(0.5),
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: theme.sp(3),
                ),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          // Fixed action buttons row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.wp(2),
              vertical: theme.hp(1.5),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout based on available width
                if (constraints.maxWidth > 500) {
                  // For wider screens, show buttons in a row
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        theme,
                        icon: Icons.play_arrow,
                        label: 'Call Numbers',
                        color: theme.primaryColor,
                        onPressed:
                            isPast
                                ? null
                                : () => _navigateToNumberCaller(contest),
                      ),
                      _buildActionButton(
                        theme,
                        icon:
                            isActive ? Icons.pause : Icons.play_circle_outline,
                        label: isActive ? 'Deactivate' : 'Activate',
                        color: isActive ? Colors.orange : Colors.green,
                        onPressed:
                            isPast ? null : () => _toggleContestStatus(contest),
                      ),
                      _buildActionButton(
                        theme,
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        color: Colors.red,
                        onPressed:
                            isActive ? null : () => _deleteContest(contest),
                      ),
                    ],
                  );
                } else {
                  // For narrower screens, show buttons in a column
                  return Column(
                    children: [
                      _buildActionButton(
                        theme,
                        icon: Icons.play_arrow,
                        label: 'Call Numbers',
                        color: theme.primaryColor,
                        onPressed:
                            isPast
                                ? null
                                : () => _navigateToNumberCaller(contest),
                        fullWidth: true,
                      ),
                      _buildActionButton(
                        theme,
                        icon:
                            isActive ? Icons.pause : Icons.play_circle_outline,
                        label: isActive ? 'Deactivate' : 'Activate',
                        color: isActive ? Colors.orange : Colors.green,
                        onPressed:
                            isPast ? null : () => _toggleContestStatus(contest),
                        fullWidth: true,
                      ),
                      _buildActionButton(
                        theme,
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        color: Colors.red,
                        onPressed:
                            isActive ? null : () => _deleteContest(contest),
                        fullWidth: true,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    AppTheme theme, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed == null ? Colors.grey : color,
          size: theme.sp(5),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: onPressed == null ? Colors.grey : color,
            fontSize: theme.sp(3.5),
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: theme.wp(2),
            vertical: theme.hp(1),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToNumberCaller(Contest contest) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NumberCallerScreen(
              contestId: contest.id,
              contestTitle: contest.title,
            ),
      ),
    );
  }

  Future<void> _toggleContestStatus(Contest contest) async {
    try {
      await widget.contestService.toggleContestStatus(contest.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              contest.isActive
                  ? 'Contest deactivated successfully'
                  : 'Contest activated successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating contest: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteContest(Contest contest) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Contest'),
            content: Text(
              'Are you sure you want to delete "${contest.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await widget.contestService.deleteContest(contest.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contest deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error deleting contest: ${e.toString()}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
