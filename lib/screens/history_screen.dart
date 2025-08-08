import 'package:app/remote/providers/employee_provider.dart';
import 'package:app/remote/models/history_model.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  EmployeeProvider? employeeProvider;
  String _selectedFilter = 'Today';
  final List<String> _filterOptions = ['Today', 'This Week', 'This Month'];

  Future<void> _loadHistory() async {
    try {
      await employeeProvider!.getHistory();
    } catch (e) {
      // Error handling is done in the provider
    }
  }

  @override
  void initState() {
    super.initState();
    employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, employeeProvider, child) {
        final historyTitle = 'Visit History'.tr();
        final isHistoryLoading = employeeProvider.isHistoryLoading;
        final history = employeeProvider.history;
        return Scaffold(
          appBar: CommonAppBar(
            title: historyTitle,
            showBackButton: false,
            showMenu: false,
          ),
          body: isHistoryLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // Filter Section
                    _buildFilterSection(),

                    // History List
                    Expanded(
                      child: _getFilteredHistory(history ?? []).isEmpty
                          ? _buildEmptyState()
                          : _buildHistoryList(history ?? []),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PrimeColors.pureWhite,
        boxShadow: [
          BoxShadow(
            color: PrimeColors.lightGray.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Period'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PrimeColors.pureBlack,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor:
                        PrimeColors.lightGray.withValues(alpha: 0.1),
                    selectedColor:
                        PrimeColors.primaryRed.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? PrimeColors.primaryRed
                          : PrimeColors.pureBlack,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? PrimeColors.primaryRed
                          : PrimeColors.lightGray.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: PrimeColors.lightGray,
          ),
          const SizedBox(height: 16),
          Text(
            'No History Found'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PrimeColors.pureBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No ${_selectedFilter.toLowerCase()} history available'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: PrimeColors.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<HistoryModel> history) {
    // Filter the history based on selected filter
    final filteredHistory = _getFilteredHistory(history);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredHistory.length,
      itemBuilder: (context, index) {
        final item = filteredHistory[index];
        return _buildHistoryCard(item);
      },
    );
  }

  List<HistoryModel> _getFilteredHistory(List<HistoryModel> history) {
    if (_selectedFilter == 'All') return history;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return history.where((item) {
      if (item.createdAt == null || item.createdAt!.isEmpty) return false;

      try {
        // Handle different date formats
        DateTime itemDate;
        if (item.createdAt!.contains('-')) {
          // Format: "2024-01-15" or "07-08-2025"
          if (item.createdAt!.split('-')[0].length == 4) {
            // Format: "2024-01-15"
            itemDate = DateTime.parse(item.createdAt!);
          } else {
            // Format: "07-08-2025" (DD-MM-YYYY)
            final parts = item.createdAt!.split('-');
            itemDate = DateTime(
                int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        } else {
          // Try direct parsing
          itemDate = DateTime.parse(item.createdAt!);
        }

        final itemDateOnly = DateTime(
          itemDate.year,
          itemDate.month,
          itemDate.day,
        );

        switch (_selectedFilter) {
          case 'Today':
            return itemDateOnly.isAtSameMomentAs(today);
          case 'This Week':
            final weekStart = today.subtract(Duration(days: today.weekday - 1));
            final weekEnd = weekStart.add(const Duration(days: 6));
            return itemDateOnly
                    .isAfter(weekStart.subtract(const Duration(days: 1))) &&
                itemDateOnly.isBefore(weekEnd.add(const Duration(days: 1)));
          case 'This Month':
            return itemDateOnly.year == today.year &&
                itemDateOnly.month == today.month;
          default:
            return true;
        }
      } catch (e) {
        // If date parsing fails, include the item for debugging
        return true;
      }
    }).toList();
  }

  Widget _buildHistoryCard(HistoryModel item) {
    final isCompleted = item.details?.first.action == 'Completed';
    final isVisit = item.details?.first.action == 'Visit' ||
        item.details?.first.action == 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PrimeColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PrimeColors.lightGray.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () => _showHistoryDetails(item),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Type Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isVisit
                        ? PrimeColors.primaryRed.withValues(alpha: .1)
                        : PrimeColors.darkRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isVisit ? Icons.visibility : Icons.shopping_cart,
                    size: 20,
                    color:
                        isVisit ? PrimeColors.primaryRed : PrimeColors.darkRed,
                  ),
                ),
                const SizedBox(width: 12),

                // Client Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.client ?? 'Unknown Client',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: PrimeColors.pureBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Employee: ${item.employee ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: PrimeColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.details?.first.action ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: PrimeColors.lightGray,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(item.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: PrimeColors.lightGray,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Notes Preview
            if (item.details?.first.note?.isNotEmpty == true) ...[
              Text(
                item.details!.first.note!,
                style: TextStyle(
                  fontSize: 12,
                  color: PrimeColors.pureBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 8),

            // Photos indicator
            if (item.images?.isNotEmpty == true) ...[
              Row(
                children: [
                  Icon(
                    Icons.photo_library,
                    size: 14,
                    color: PrimeColors.lightGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.images!.length} ${'Images'.tr()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: PrimeColors.lightGray,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown Date';

    try {
      // Handle different date formats
      DateTime date;
      if (dateString.contains('-')) {
        // Format: "2024-01-15" or "07-08-2025"
        if (dateString.split('-')[0].length == 4) {
          // Format: "2024-01-15"
          date = DateTime.parse(dateString);
        } else {
          // Format: "07-08-2025" (DD-MM-YYYY)
          final parts = dateString.split('-');
          date = DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      } else {
        // Try direct parsing
        date = DateTime.parse(dateString);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(date.year, date.month, date.day);

      if (itemDate.isAtSameMomentAs(today)) {
        return 'Today'.tr();
      } else if (itemDate.isAtSameMomentAs(yesterday)) {
        return 'Yesterday'.tr();
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      // Return the original string if parsing fails
      return dateString;
    }
  }

  void _showHistoryDetails(HistoryModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HistoryDetailsSheet(item: item),
    );
  }
}

class _HistoryDetailsSheet extends StatelessWidget {
  final HistoryModel item;

  const _HistoryDetailsSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: PrimeColors.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: PrimeColors.lightGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.client ?? 'Unknown Client',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PrimeColors.pureBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Employee: ${item.employee ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: PrimeColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  _buildDetailRow(
                    'Date'.tr(),
                    _formatFullDate(item.createdAt),
                    Icons.calendar_today,
                  ),

                  const SizedBox(height: 20),

                  // Notes
                  if (item.details?.first.note?.isNotEmpty == true) ...[
                    Text(
                      'Notes'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: PrimeColors.pureBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: PrimeColors.lightGray.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: PrimeColors.lightGray.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        item.details!.first.note!,
                        style: TextStyle(
                          fontSize: 14,
                          color: PrimeColors.pureBlack,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Photos
                  if (item.images?.isNotEmpty == true) ...[
                    Text(
                      'Photos'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: PrimeColors.pureBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: item.images!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color:
                                  PrimeColors.lightGray.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.photo,
                              size: 32,
                              color: PrimeColors.lightGray,
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown Date';

    try {
      // Handle different date formats
      DateTime date;
      if (dateString.contains('-')) {
        // Format: "2024-01-15" or "07-08-2025"
        if (dateString.split('-')[0].length == 4) {
          // Format: "2024-01-15"
          date = DateTime.parse(dateString);
        } else {
          // Format: "07-08-2025" (DD-MM-YYYY)
          final parts = dateString.split('-');
          date = DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      } else {
        // Try direct parsing
        date = DateTime.parse(dateString);
      }

      return DateFormat('EEEE, MMMM dd, yyyy').format(date);
    } catch (e) {
      // Return the original string if parsing fails
      return dateString;
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: PrimeColors.primaryRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: PrimeColors.primaryRed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: PrimeColors.lightGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: PrimeColors.pureBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
