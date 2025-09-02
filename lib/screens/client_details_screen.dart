import 'package:app/remote/models/client_model.dart';
import 'package:app/remote/providers/employee_provider.dart';
import 'package:app/utils/common.dart';
import 'package:app/utils/theme.dart';
import 'package:app/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:provider/provider.dart';
import 'package:app/remote/providers/auth_provider.dart';
import 'dart:io';

class ClientDetailsScreen extends StatefulWidget {
  final ClientModel client;

  const ClientDetailsScreen({
    super.key,
    required this.client,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen>
    with CommonFunction {
  final List<String> _selectedSalesOptions = [];
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<String> selectedImages = [];
  final picker = ImagePicker();
  Future getImages() async {
    MultipleImageCamera.capture(context: context).then((finalImages) async {
      if (finalImages.isNotEmpty) {
        for (var images in finalImages) {
          selectedImages.add(images.file.path);
        }
        setState(() {});
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(milliseconds: 500),
              content: Text('Nothing is selected')));
        }
      }
    });
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PrimeColors.pureWhite,
                  PrimeColors.lightGray.withOpacity(0.05),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client Image Section
                  if (widget.client.boardImage?.isNotEmpty ?? false)
                    Container(
                      width: double.infinity,
                      height: 200,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: PrimeColors.pureBlack.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: widget.client.boardImage?.first ?? '',
                          placeholder: (context, url) => Container(
                            color: PrimeColors.lightGray.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: PrimeColors.primaryRed,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: PrimeColors.lightGray.withOpacity(0.3),
                            child: const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: PrimeColors.lightGray,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // Header Card with Shop Info
                  _buildHeaderCard(),
                  const SizedBox(height: 24),

                  // Contact Information
                  _buildSectionCard(
                    title: 'Store Information'.tr(),
                    icon: Icons.contact_phone,
                    children: [
                      if (widget.client.ownerName != null)
                        _buildInfoTile(
                          icon: Icons.person,
                          title: 'Owner'.tr(),
                          subtitle: widget.client.ownerName!,
                        ),
                      if (widget.client.managerName != null)
                        _buildInfoTile(
                          icon: Icons.manage_accounts,
                          title: 'Manager'.tr(),
                          subtitle: widget.client.managerName!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
        ));
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
              decoration: BoxDecoration(
                border:
                    Border.all(color: PrimeColors.lightGray.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
                color: PrimeColors.pureWhite,
              ),
              child: Column(
                children: [
                  // Image Grid
                  if (selectedImages.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = selectedImages[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: PrimeColors.pureBlack.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(image),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  // Delete button overlay
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: PrimeColors.primaryRed
                                            .withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: PrimeColors.pureBlack
                                                .withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: PrimeColors.pureWhite,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedImages.remove(image);
                                          });
                                        },
                                        constraints: const BoxConstraints(
                                          minWidth: 28,
                                          minHeight: 28,
                                        ),
                                        padding: EdgeInsets.zero,
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
                    const Divider(
                        height: 1, thickness: 1, color: PrimeColors.lightGray),
                  ],
                  // Add photos button
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        getImages();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimeColors.primaryRed,
                        foregroundColor: PrimeColors.pureWhite,
                        elevation: 2,
                        shadowColor: PrimeColors.primaryRed.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.add_a_photo, size: 20),
                      label: Text(
                        selectedImages.isEmpty
                            ? 'Add Photos'.tr()
                            : 'Add More Photos'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: PrimeColors.pureWhite,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: PrimeColors.lightGray.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: PrimeColors.pureBlack.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Note'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: PrimeColors.pureBlack,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 4,
                      autocorrect: false,
                      enableSuggestions: false,
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
                        hintText: 'Enter your notes here...'.tr(),
                        hintStyle: TextStyle(
                          color: PrimeColors.lightGray,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: PrimeColors.pureWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: PrimeColors.lightGray.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: PrimeColors.lightGray.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: PrimeColors.primaryRed,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: PrimeColors.primaryRed.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Consumer<EmployeeProvider>(
                  builder: (context, employeeProvider, child) {
                return ElevatedButton.icon(
                  onPressed: _noteController.text.isNotEmpty &&
                          selectedImages.isNotEmpty &&
                          !employeeProvider.isTMRSubmitLoading
                      ? () {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          final note = _noteController.text.trim();
                          final images = selectedImages;
                          final clientId = widget.client.id;

                          employeeProvider
                              .submitTMRActivities(
                                  images, clientId.toString(), note)
                              .then((value) {
                            if (value != null) {
                              if (value.isSuccess!) {
                                _clearNote();
                                selectedImages.clear();
                                context.go('/');
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(value.message!),
                                    backgroundColor: PrimeColors.successGreen,
                                  ),
                                );
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(value.message!),
                                    backgroundColor: PrimeColors.primaryRed,
                                  ),
                                );
                              }
                            }
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _noteController.text.isNotEmpty &&
                            selectedImages.isNotEmpty
                        ? PrimeColors.primaryRed
                        : PrimeColors.lightGray,
                    foregroundColor: PrimeColors.pureWhite,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: PrimeColors.lightGray,
                    disabledForegroundColor: PrimeColors.pureWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 20),
                  label: Text(
                    'Submit'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
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
            Consumer<EmployeeProvider>(
                builder: (context, employeeProvider, child) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _selectedSalesOptions.isEmpty ||
                          employeeProvider.isSubmitLoading
                      ? null
                      : () {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          employeeProvider
                              .submitSalesActivities(_selectedSalesOptions,
                                  widget.client.id.toString())
                              .then((value) {
                            if (value != null) {
                              if (value.isSuccess!) {
                                _clearSalesSelections();
                                context.go('/');
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(value.message!).tr(),
                                    backgroundColor: PrimeColors.successGreen,
                                  ),
                                );
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(value.message!),
                                    backgroundColor: PrimeColors.primaryRed,
                                  ),
                                );
                              }
                            }
                          });
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
              );
            }),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: PrimeColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PrimeColors.lightGray.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: PrimeColors.pureBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: PrimeColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PrimeColors.primaryRed.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: PrimeColors.primaryRed,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: PrimeColors.pureBlack,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
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
