import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tambola/Theme/app_theme.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);
    //final adminProvider = Provider.of<AdminProvider>(context);

    return SingleChildScrollView(
      padding: theme.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, Admin', style: theme.headingStyle),
          SizedBox(height: theme.hp(2)),
          _buildStatusCards(context, theme),
          SizedBox(height: theme.hp(3)),
          // _buildQuickActions(context, theme, adminProvider),
          SizedBox(height: theme.hp(3)),
          _buildRecentActivity(context, theme),
        ],
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context, AppTheme theme) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: theme.wp(3),
      mainAxisSpacing: theme.hp(2),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatusCard(
          context,
          theme,
          'Active Contests',
          '12',
          Icons.casino,
          Colors.blue,
        ),
        _buildStatusCard(
          context,
          theme,
          'Total Users',
          '1,245',
          Icons.people,
          Colors.green,
        ),
        _buildStatusCard(
          context,
          theme,
          'Today\'s Revenue',
          '₹12,500',
          Icons.monetization_on,
          Colors.amber,
        ),
        _buildStatusCard(
          context,
          theme,
          'Pending Payouts',
          '8',
          Icons.payment,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    AppTheme theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: theme.cardBorderRadius),
      child: Padding(
        padding: EdgeInsets.all(theme.wp(4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: theme.hp(6), color: color),
            SizedBox(height: theme.hp(1)),
            Text(
              value,
              style: theme.headingStyle.copyWith(
                fontSize: theme.sp(7),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: theme.hp(0.5)),
            Text(
              title,
              style: theme.bodyStyle.copyWith(color: theme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    AppTheme theme,
    //AdminProvider adminProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.subheadingStyle),
        SizedBox(height: theme.hp(1.5)),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: theme.cardBorderRadius),
          child: Padding(
            padding: EdgeInsets.all(theme.wp(4)),
            child: Column(
              children: [
                // SwitchListTile(
                //   title: Text(
                //     'Enable Contest Creation',
                //     style: theme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(
                //     'Allow users to create new contests',
                //     style: TextStyle(
                //       fontSize: theme.sp(3.5),
                //       color: theme.textSecondaryColor,
                //     ),
                //   ),
                //   value: adminProvider.isContestCreationEnabled,
                //   onChanged: (value) {
                //     adminProvider.setContestCreationEnabled(value);
                //   },
                //   activeColor: theme.primaryColor,
                // ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.add_circle, color: theme.primaryColor),
                  title: Text(
                    'Create New Contest',
                    style: theme.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ContestManagementScreen(),
                    //   ),
                    // );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.mic, color: theme.primaryColor),
                  title: Text(
                    'Start Number Calling',
                    style: theme.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const NumberCallerScreen(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, AppTheme theme) {
    final activities = [
      {
        'title': 'New Contest Created',
        'description': 'Big Jackpot Tambola - ₹10,000 Prize',
        'time': '10 minutes ago',
        'icon': Icons.casino,
        'color': Colors.blue,
      },
      {
        'title': 'User Payout Processed',
        'description': 'Rahul S. - ₹2,500',
        'time': '1 hour ago',
        'icon': Icons.payment,
        'color': Colors.green,
      },
      {
        'title': 'Contest Completed',
        'description': 'Weekend Special Tambola',
        'time': '3 hours ago',
        'icon': Icons.check_circle,
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: theme.subheadingStyle),
        SizedBox(height: theme.hp(1.5)),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: theme.cardBorderRadius),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (activity['color'] as Color).withOpacity(
                    0.2,
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: theme.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  activity['description'] as String,
                  style: TextStyle(
                    fontSize: theme.sp(3.5),
                    color: theme.textSecondaryColor,
                  ),
                ),
                trailing: Text(
                  activity['time'] as String,
                  style: TextStyle(
                    fontSize: theme.sp(3),
                    color: theme.textSecondaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
