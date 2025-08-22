import 'package:app/remote/models/client_model.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/remote/providers/auth_provider.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ClientModel client;

  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final List<String> _selectedSalesOptions = [];
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _clearSalesSelections() {
    setState(() {
      _selectedSalesOptions.clear();
    });
  }

  void _clearNote() {
    setState(() {
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.client.boardName ?? 'Client Details'.tr(),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.client.crImage?.isNotEmpty ?? false
                  ? CachedNetworkImage(
                      imageUrl: widget.client.crImage?.first ?? '',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : SizedBox.shrink(),
              // Header Card with Shop Info
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Contact Information
              _buildSectionCard(
                title: 'Contact Information'.tr(),
                icon: Icons.contact_phone,
                children: [
                  if (widget.client.ownerName != null)
                    _buildInfoTile(
                      icon: Icons.person,
                      title: 'Owner'.tr(),
                      subtitle: widget.client.ownerName!,
                      trailing: widget.client.ownerPhone != null
                          ? IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                // TODO: Make phone call
                              },
                            )
                          : null,
                    ),
                  if (widget.client.managerName != null)
                    _buildInfoTile(
                      icon: Icons.manage_accounts,
                      title: 'Manager'.tr(),
                      subtitle: widget.client.managerName!,
                      trailing: widget.client.managerPhone != null
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
                  if (widget.client.shopCode != null)
                    _buildInfoTile(
                      icon: Icons.qr_code,
                      title: 'Shop Code'.tr(),
                      subtitle: widget.client.shopCode!,
                    ),
                  if (widget.client.vatNumber != null)
                    _buildInfoTile(
                      icon: Icons.receipt,
                      title: 'VAT Number'.tr(),
                      subtitle: widget.client.vatNumber.toString(),
                    ),
                  if (widget.client.shopSalesClassification != null)
                    _buildInfoTile(
                      icon: Icons.analytics,
                      title: 'Sales Classification'.tr(),
                      subtitle: widget.client.shopSalesClassification!,
                    ),
                  if (widget.client.shopDecoration != null)
                    _buildInfoTile(
                      icon: Icons.storefront,
                      title: 'Shop Decoration'.tr(),
                      subtitle: widget.client.shopDecoration!,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Information
              _buildSectionCard(
                title: 'Location'.tr(),
                icon: Icons.location_on,
                children: [
                  if (widget.client.neighborhood != null)
                    _buildInfoTile(
                      icon: Icons.location_city,
                      title: 'Neighborhood'.tr(),
                      subtitle: widget.client.neighborhood!,
                    ),
                  if (widget.client.cityName != null)
                    _buildInfoTile(
                      icon: Icons.location_city,
                      title: 'City'.tr(),
                      subtitle: widget.client.cityName!,
                    ),
                  if (widget.client.subcityName != null)
                    _buildInfoTile(
                      icon: Icons.location_city,
                      title: 'Subcity'.tr(),
                      subtitle: widget.client.subcityName!,
                    ),
                  if (widget.client.regionName != null)
                    _buildInfoTile(
                      icon: Icons.map,
                      title: 'Region'.tr(),
                      subtitle: widget.client.regionName!,
                    ),
                  if (widget.client.latitude != null &&
                      widget.client.longitude != null)
                    _buildInfoTile(
                      icon: Icons.gps_fixed,
                      title: 'Coordinates'.tr(),
                      subtitle:
                          '${widget.client.latitude}, ${widget.client.longitude}',
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
              if (widget.client.chainName != null) ...[
                _buildSectionCard(
                  title: 'Chain Information'.tr(),
                  icon: Icons.account_tree,
                  children: [
                    _buildInfoTile(
                      icon: Icons.business_center,
                      title: 'Chain Name'.tr(),
                      subtitle: widget.client.chainName!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // // Documents Section
              // _buildSectionCard(
              //   title: 'Documents'.tr(),
              //   icon: Icons.description,
              //   children: [
              //     if (client.crImage != null && client.crImage!.isNotEmpty)
              //       _buildDocumentTile(
              //         icon: Icons.description,
              //         title: 'CR Documents'.tr(),
              //         count: client.crImage!.length,
              //         onTap: () {
              //           // TODO: View CR documents
              //         },
              //       ),
              //     if (client.boardImage != null && client.boardImage!.isNotEmpty)
              //       _buildDocumentTile(
              //         icon: Icons.image,
              //         title: 'Board Images'.tr(),
              //         count: client.boardImage!.length,
              //         onTap: () {
              //           // TODO: View board images
              //         },
              //       ),
              //   ],
              // ),
              // const SizedBox(height: 32),

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
      ),
    );
  }

  Widget _buildTmrActions(BuildContext context) {
    return Column(
      children: [
        // Photo Upload Section
        _buildSectionCard(
          title: 'Upload Photos'.tr(),
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
                    'Tap to add photos'.tr(),
                    style: TextStyle(
                      color: PrimeColors.lightGray,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your notes'.tr();
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Add Note'.tr(),
                hintText: 'Enter your notes here...'.tr(),
                hintStyle: TextStyle(
                  color: PrimeColors.lightGray,
                  fontSize: 14,
                ),
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
                onPressed: _noteController.text.isNotEmpty
                    ? () {
                        // TODO: Handle photo upload with note
                        final note = _noteController.text.trim();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(note.isNotEmpty
                                ? 'Photos uploaded with note: $note'
                                : 'Photos uploaded successfully!'),
                            backgroundColor: PrimeColors.primaryRed,
                          ),
                        );
                        _clearNote();
                      }
                    : null,
                icon: const Icon(Icons.upload),
                label: Text(
                  'Upload Photos & Note'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesActions(BuildContext context) {
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
              value: _selectedSalesOptions.contains('socialization'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedSalesOptions.add('socialization');
                  } else {
                    _selectedSalesOptions.remove('socialization');
                  }
                });
              },
            ),
            _buildCheckboxTile(
              title: 'Sales'.tr(),
              subtitle: 'Product sales activities'.tr(),
              icon: Icons.shopping_cart,
              value: _selectedSalesOptions.contains('sales'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedSalesOptions.add('sales');
                  } else {
                    _selectedSalesOptions.remove('sales');
                  }
                });
              },
            ),
            _buildCheckboxTile(
              title: 'Collection'.tr(),
              subtitle: 'Payment collection'.tr(),
              icon: Icons.payment,
              value: _selectedSalesOptions.contains('collection'),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedSalesOptions.add('collection');
                  } else {
                    _selectedSalesOptions.remove('collection');
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _selectedSalesOptions.isEmpty
                    ? null
                    : () {
                        // TODO: Handle sales activity submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Activities submitted: ${_selectedSalesOptions.join(', ')}'),
                            backgroundColor: PrimeColors.primaryRed,
                          ),
                        );
                        _clearSalesSelections();
                      },
                icon: const Icon(Icons.check),
                label: Text(
                  'Submit'.tr(),
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
    required bool value,
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
              value: value,
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
              widget.client.boardName ?? 'Unknown Shop'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: PrimeColors.pureWhite,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.client.shopCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Code: ${widget.client.shopCode}'.tr(),
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
