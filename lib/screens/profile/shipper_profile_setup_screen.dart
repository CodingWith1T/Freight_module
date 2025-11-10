import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/shipper_profile.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/document_upload_card.dart';

class ShipperProfileSetupScreen extends StatefulWidget {
  const ShipperProfileSetupScreen({super.key});

  @override
  State<ShipperProfileSetupScreen> createState() =>
      _ShipperProfileSetupScreenState();
}

class _ShipperProfileSetupScreenState extends State<ShipperProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _yearsInBusinessController =
      TextEditingController();
  final TextEditingController _monthlyLoadController = TextEditingController();
  final TextEditingController _officeAddressController =
      TextEditingController();

  String _shipperType = 'Individual';
  bool _isVerified = false;
  DateTime? _verifiedAt;

  final Map<String, DocumentFile?> _documents = {
    'PAN': null,
    'Aadhaar': null,
    'GST': null,
    'Other': null,
  };

  double get _completionPercentage {
    const int totalFields = 8;
    int filledFields = 0;

    if (_shipperType.isNotEmpty) filledFields++;
    if (_shipperType == 'Company' &&
        _companyNameController.text.trim().isNotEmpty) {
      filledFields++;
    }
    if (_yearsInBusinessController.text.trim().isNotEmpty) filledFields++;
    if (_monthlyLoadController.text.trim().isNotEmpty) filledFields++;
    if (_officeAddressController.text.trim().isNotEmpty) filledFields++;
    if (_documents['PAN'] != null) filledFields++;
    if (_documents['Aadhaar'] != null) filledFields++;
    if (_documents['GST'] != null) filledFields++;

    return (filledFields / totalFields) * 100;
  }

  bool get _isFormValid {
    final bool basicValid =
        _yearsInBusinessController.text.trim().isNotEmpty &&
        _monthlyLoadController.text.trim().isNotEmpty &&
        _officeAddressController.text.trim().isNotEmpty;

    final bool companyValid =
        _shipperType == 'Individual' ||
        (_shipperType == 'Company' &&
            _companyNameController.text.trim().isNotEmpty);

    final bool docsValid =
        _documents['PAN'] != null &&
        _documents['Aadhaar'] != null &&
        _documents['GST'] != null;

    return basicValid && companyValid && docsValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildBasicInformationSection(),
                    const SizedBox(height: 24),
                    _buildVerificationSection(),
                    const SizedBox(height: 24),
                    _buildDocumentUploadsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Profile Setup',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator() {
    final int percent = _completionPercentage.toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.cardDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percent% Completed',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$percent/100',
                style: AppTextStyles.caption.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: const Color(0xFF3A3A3A),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete Your Business Profile',
          style: AppTextStyles.headline1.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 8),
        Text(
          'Please fill your business and verification details to start shipping.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey.shade400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInformationSection() {
    return _buildSectionContainer(
      title: 'Basic Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipper Type',
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _shipperType,
            decoration: _inputDecoration('Select shipper type'),
            dropdownColor: AppColors.cardDark,
            style: AppTextStyles.bodyLarge,
            items: const ['Individual', 'Company']
                .map(
                  (value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value == null) return;
              setState(() {
                _shipperType = value;
              });
            },
          ),
          if (_shipperType == 'Company') ...[
            const SizedBox(height: 20),
            CustomTextField(
              controller: _companyNameController,
              label: 'Company Name',
              hint: 'Enter company name',
              maxLength: 150,
              validator: (value) {
                if (_shipperType == 'Company' &&
                    (value == null || value.trim().isEmpty)) {
                  return 'Company name is required';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: 20),
          CustomTextField(
            controller: _yearsInBusinessController,
            label: 'Years in Business',
            hint: 'Enter years in business',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _monthlyLoadController,
            label: 'Monthly Expected Load',
            hint: 'Enter monthly load (in tons)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _officeAddressController,
            label: 'Office Address',
            hint: 'Enter complete office address',
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return _buildSectionContainer(
      title: 'Verification Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isVerified
                    ? AppColors.primary
                    : const Color(0xFF3A3A3A),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isVerified
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isVerified ? Icons.verified : Icons.pending,
                    color: _isVerified ? AppColors.primary : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified by Team',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isVerified
                            ? 'Profile verified'
                            : 'Pending verification',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isVerified,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _isVerified = value;
                      _verifiedAt = value ? DateTime.now() : null;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isVerified && _verifiedAt != null) ...[
            const SizedBox(height: 16),
            Text(
              'Verified At',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_verifiedAt!.day}/${_verifiedAt!.month}/${_verifiedAt!.year} at '
                    '${_verifiedAt!.hour}:${_verifiedAt!.minute.toString().padLeft(2, '0')}',
                    style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentUploadsSection() {
    return _buildSectionContainer(
      title: 'Document Uploads',
      subtitle: 'Upload required documents for verification',
      child: Column(
        children: [
          DocumentUploadCard(
            title: 'PAN Document',
            subtitle: 'Upload PAN card',
            icon: Icons.credit_card,
            isRequired: true,
            document: _documents['PAN'],
            onUpload: () => _pickDocument('PAN'),
            onRemove: () => _removeDocument('PAN'),
          ),
          const SizedBox(height: 12),
          DocumentUploadCard(
            title: 'Aadhaar Document',
            subtitle: 'Upload Aadhaar card',
            icon: Icons.badge,
            isRequired: true,
            document: _documents['Aadhaar'],
            onUpload: () => _pickDocument('Aadhaar'),
            onRemove: () => _removeDocument('Aadhaar'),
          ),
          const SizedBox(height: 12),
          DocumentUploadCard(
            title: 'GST Document',
            subtitle: 'Upload GST certificate',
            icon: Icons.receipt_long,
            isRequired: true,
            document: _documents['GST'],
            onUpload: () => _pickDocument('GST'),
            onRemove: () => _removeDocument('GST'),
          ),
          const SizedBox(height: 12),
          DocumentUploadCard(
            title: 'Other Documents',
            subtitle: 'Upload additional documents (optional)',
            icon: Icons.folder_open,
            isRequired: false,
            document: _documents['Other'],
            onUpload: () => _pickDocument('Other'),
            onRemove: () => _removeDocument('Other'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    Widget? child,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headline2.copyWith(fontSize: 18)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ],
          if (child != null) ...[const SizedBox(height: 20), child],
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isFormValid ? _saveAndContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: const Color(0xFF3A3A3A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isFormValid ? 'Save & Continue' : 'Complete all fields',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: _isFormValid ? AppColors.white : AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isFormValid) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption.copyWith(color: const Color(0xFF666666)),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Future<void> _pickDocument(String docType) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: _DocumentPickerSheet(
          onSelect: (DocumentFile file) {
            setState(() {
              _documents[docType] = file;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _removeDocument(String docType) {
    setState(() {
      _documents[docType] = null;
    });
  }

  void _saveAndContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _isVerified);
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _yearsInBusinessController.dispose();
    _monthlyLoadController.dispose();
    _officeAddressController.dispose();
    super.dispose();
  }
}

class _DocumentPickerSheet extends StatelessWidget {
  final ValueChanged<DocumentFile> onSelect;

  const _DocumentPickerSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Upload Document',
          style: AppTextStyles.headline2.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 20),
        _DocumentPickerTile(
          icon: Icons.camera_alt,
          title: 'Take Photo',
          onTap: () => onSelect(
            const DocumentFile(
              name: 'document-photo.jpg',
              path: '/path/to/photo.jpg',
              type: 'image',
            ),
          ),
        ),
        _DocumentPickerTile(
          icon: Icons.photo_library,
          title: 'Choose from Gallery',
          onTap: () => onSelect(
            const DocumentFile(
              name: 'document-image.jpg',
              path: '/path/to/image.jpg',
              type: 'image',
            ),
          ),
        ),
        _DocumentPickerTile(
          icon: Icons.insert_drive_file,
          title: 'Choose File',
          onTap: () => onSelect(
            const DocumentFile(
              name: 'document.pdf',
              path: '/path/to/document.pdf',
              type: 'pdf',
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentPickerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DocumentPickerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      onTap: onTap,
    );
  }
}
