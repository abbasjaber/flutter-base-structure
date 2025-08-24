import 'package:app/remote/providers/employee_provider.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/app_icons.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TmrHomeScreen extends StatefulWidget {
  const TmrHomeScreen({super.key, required this.title});
  final String title;
  @override
  State<TmrHomeScreen> createState() => _TmrHomeScreenState();
}

class _TmrHomeScreenState extends State<TmrHomeScreen> {
  EmployeeProvider? employeeProvider;

  Future<void> _loadClients() async {
    try {
      await employeeProvider!.getClients();
    } catch (e) {
      // Error handling is done in the provider
    }
  }

  @override
  void initState() {
    super.initState();
    employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.title,
        showBackButton: false,
        onRefresh: _loadClients,
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          // Show loading state from provider
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(PrimeColors.primaryRed),
              ),
            );
          }

          final clients = provider.clients;
          if (clients == null || clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcons.storeIcon(
                    size: 64,
                    color: PrimeColors.lightGray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No clients found'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: PrimeColors.lightGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There are no clients assigned to you yet.'.tr(),
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

          return RefreshIndicator(
            onRefresh: _loadClients,
            color: PrimeColors.primaryRed,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shadowColor: PrimeColors.primaryRed.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: PrimeColors.lightGray.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.push('/client-details', extra: client);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            PrimeColors.pureWhite,
                            PrimeColors.pureWhite.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Client Image/Icon
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    PrimeColors.primaryRed
                                        .withValues(alpha: 0.1),
                                    PrimeColors.primaryRed
                                        .withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: PrimeColors.primaryRed
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: client.boardImage?.isNotEmpty ?? false
                                  ? CachedNetworkImage(
                                      imageUrl: client.boardImage?.first ?? '',
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : const Icon(Icons.store),
                            ),
                            const SizedBox(width: 16),

                            // Client Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.boardName ?? 'Unknown Shop'.tr(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: PrimeColors.pureBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (client.shopCode != null)
                                    Text(
                                      'Code: ${client.shopCode}'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimeColors.lightGray,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Navigation Arrow
                            Icon(
                              Icons.arrow_forward_ios,
                              color: PrimeColors.lightGray,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
