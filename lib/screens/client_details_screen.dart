import 'package:app/remote/models/client_model.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/remote/providers/auth_provider.dart';

class ClientDetailsScreen extends StatelessWidget {
  final ClientModel client;

  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: client.boardName ?? 'Client Details'.tr(),
        showMenu: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit client screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: client.crImage?.first ?? '',
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // Header Card with Shop Info
            _buildHeaderCard(),
            const SizedBox(height: 16),

            // Contact Information
            _buildSectionCard(
              title: 'Contact Information'.tr(),
              icon: Icons.contact_phone,
              children: [
                if (client.ownerName != null)
                  _buildInfoTile(
                    icon: Icons.person,
                    title: 'Owner'.tr(),
                    subtitle: client.ownerName!,
                    trailing: client.ownerPhone != null
                        ? IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              // TODO: Make phone call
                            },
                          )
                        : null,
                  ),
                if (client.managerName != null)
                  _buildInfoTile(
                    icon: Icons.manage_accounts,
                    title: 'Manager'.tr(),
                    subtitle: client.managerName!,
                    trailing: client.managerPhone != null
                        ? IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              // TODO: Make phone call
                            },
                          )
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Business Information
            _buildSectionCard(
              title: 'Business Information'.tr(),
              icon: Icons.business,
              children: [
                if (client.shopCode != null)
                  _buildInfoTile(
                    icon: Icons.qr_code,
                    title: 'Shop Code'.tr(),
                    subtitle: client.shopCode!,
                  ),
                if (client.vatNumber != null)
                  _buildInfoTile(
                    icon: Icons.receipt,
                    title: 'VAT Number'.tr(),
                    subtitle: client.vatNumber.toString(),
                  ),
                if (client.shopSalesClassification != null)
                  _buildInfoTile(
                    icon: Icons.analytics,
                    title: 'Sales Classification'.tr(),
                    subtitle: client.shopSalesClassification!,
                  ),
                if (client.shopDecoration != null)
                  _buildInfoTile(
                    icon: Icons.storefront,
                    title: 'Shop Decoration'.tr(),
                    subtitle: client.shopDecoration!,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Location Information
            _buildSectionCard(
              title: 'Location'.tr(),
              icon: Icons.location_on,
              children: [
                if (client.neighborhood != null)
                  _buildInfoTile(
                    icon: Icons.location_city,
                    title: 'Neighborhood'.tr(),
                    subtitle: client.neighborhood!,
                  ),
                if (client.cityName != null)
                  _buildInfoTile(
                    icon: Icons.location_city,
                    title: 'City'.tr(),
                    subtitle: client.cityName!,
                  ),
                if (client.subcityName != null)
                  _buildInfoTile(
                    icon: Icons.location_city,
                    title: 'Subcity'.tr(),
                    subtitle: client.subcityName!,
                  ),
                if (client.regionName != null)
                  _buildInfoTile(
                    icon: Icons.map,
                    title: 'Region'.tr(),
                    subtitle: client.regionName!,
                  ),
                if (client.latitude != null && client.longitude != null)
                  _buildInfoTile(
                    icon: Icons.gps_fixed,
                    title: 'Coordinates'.tr(),
                    subtitle: '${client.latitude}, ${client.longitude}',
                    trailing: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () {
                        // TODO: Open in maps
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Chain Information
            if (client.chainName != null) ...[
              _buildSectionCard(
                title: 'Chain Information'.tr(),
                icon: Icons.account_tree,
                children: [
                  _buildInfoTile(
                    icon: Icons.business_center,
                    title: 'Chain Name'.tr(),
                    subtitle: client.chainName!,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Documents Section
            _buildSectionCard(
              title: 'Documents'.tr(),
              icon: Icons.description,
              children: [
                if (client.crImage != null && client.crImage!.isNotEmpty)
                  _buildDocumentTile(
                    icon: Icons.description,
                    title: 'CR Documents'.tr(),
                    count: client.crImage!.length,
                    onTap: () {
                      // TODO: View CR documents
                    },
                  ),
                if (client.boardImage != null && client.boardImage!.isNotEmpty)
                  _buildDocumentTile(
                    icon: Icons.image,
                    title: 'Board Images'.tr(),
                    count: client.boardImage!.length,
                    onTap: () {
                      // TODO: View board images
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Position-specific Action Buttons
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final userPosition = authProvider.userModel?.position;

                if (userPosition == 'TMR') {
                  return _buildTmrActions(context);
                } else if (userPosition == 'Sales') {
                  return _buildSalesActions(context);
                } else {
                  return _buildDefaultActions(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTmrActions(BuildContext context) {
    return Column(
      children: [
        // Photo Upload Section
        _buildSectionCard(
          title: 'Upload Photo'.tr(),
          icon: Icons.camera_alt,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: PrimeColors.lightGray),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: PrimeColors.lightGray,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add photo'.tr(),
                    style: TextStyle(
                      color: PrimeColors.lightGray,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add Note'.tr(),
                hintText: 'Enter your notes here...'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: PrimeColors.primaryRed, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Handle photo upload with note
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo uploaded successfully!'),
                      backgroundColor: PrimeColors.primaryRed,
                    ),
                  );
                },
                icon: const Icon(Icons.upload),
                label: Text(
                  'Upload Photo & Note'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDefaultActions(context),
      ],
    );
  }

  Widget _buildSalesActions(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final List<String> selectedOptions = [];

        return Column(
          children: [
            // Sales Options Section
            _buildSectionCard(
              title: 'Select Activity Type'.tr(),
              icon: Icons.checklist,
              children: [
                _buildCheckboxTile(
                  title: 'Socialization'.tr(),
                  subtitle: 'Client relationship building'.tr(),
                  icon: Icons.people,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add('socialization');
                      } else {
                        selectedOptions.remove('socialization');
                      }
                    });
                  },
                ),
                _buildCheckboxTile(
                  title: 'Sales'.tr(),
                  subtitle: 'Product sales activities'.tr(),
                  icon: Icons.shopping_cart,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add('sales');
                      } else {
                        selectedOptions.remove('sales');
                      }
                    });
                  },
                ),
                _buildCheckboxTile(
                  title: 'Collection'.tr(),
                  subtitle: 'Payment collection'.tr(),
                  icon: Icons.payment,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add('collection');
                      } else {
                        selectedOptions.remove('collection');
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: selectedOptions.isEmpty
                        ? null
                        : () {
                            // TODO: Handle sales activity submission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Activities submitted: ${selectedOptions.join(', ')}'),
                                backgroundColor: PrimeColors.primaryRed,
                              ),
                            );
                          },
                    icon: const Icon(Icons.check),
                    label: Text(
                      'Submit Activities'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to visit screen
            },
            icon: const Icon(Icons.store),
            label: Text(
              'Start Visit'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to history screen
            },
            icon: const Icon(Icons.history),
            label: Text(
              'Visit History'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: PrimeColors.primaryRed,
              side: const BorderSide(color: PrimeColors.primaryRed),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PrimeColors.pureWhite,
              PrimeColors.lightGray.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(
            color: PrimeColors.lightGray.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PrimeColors.primaryRed.withValues(alpha: 0.1),
                    PrimeColors.primaryRed.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: PrimeColors.primaryRed.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: PrimeColors.primaryRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PrimeColors.pureBlack,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: PrimeColors.lightGray,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: false, // This will be managed by StatefulBuilder
              onChanged: onChanged,
              activeColor: PrimeColors.primaryRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shadowColor: PrimeColors.primaryRed.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: PrimeColors.primaryRed.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PrimeColors.primaryRed,
              PrimeColors.darkRed,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PrimeColors.pureWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: PrimeColors.pureWhite.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.store,
                size: 40,
                color: PrimeColors.pureWhite,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              client.boardName ?? 'Unknown Shop'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: PrimeColors.pureWhite,
              ),
              textAlign: TextAlign.center,
            ),
            if (client.shopCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Code: ${client.shopCode}'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: PrimeColors.pureWhite.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shadowColor: PrimeColors.primaryRed.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: PrimeColors.lightGray.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          PrimeColors.primaryRed.withValues(alpha: 0.1),
                          PrimeColors.primaryRed.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: PrimeColors.primaryRed.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: PrimeColors.primaryRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PrimeColors.pureBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: PrimeColors.lightGray,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: PrimeColors.lightGray,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: PrimeColors.pureBlack,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildDocumentTile({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PrimeColors.pureWhite,
            PrimeColors.lightGray.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: PrimeColors.lightGray.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PrimeColors.primaryRed.withValues(alpha: 0.1),
                PrimeColors.primaryRed.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: PrimeColors.primaryRed.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: PrimeColors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: PrimeColors.pureBlack,
          ),
        ),
        subtitle: Text(
          '$count document${count > 1 ? 's' : ''}'.tr(),
          style: TextStyle(
            color: PrimeColors.lightGray,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: PrimeColors.lightGray,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
