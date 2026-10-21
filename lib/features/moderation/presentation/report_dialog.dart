import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/report_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/interaction_repository.dart';

/// Modal dialog for reporting fraudulent or offensive content.
class ReportDialog extends StatefulWidget {
  final String targetType;
  final String targetId;

  const ReportDialog({
    super.key,
    required this.targetType,
    required this.targetId,
  });

  static Future<void> show(
    BuildContext context, {
    required String targetType,
    required String targetId,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ReportDialog(targetType: targetType, targetId: targetId),
    );
  }

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportCategory _category = ReportCategory.fakePhoto;
  final TextEditingController _descController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      setState(() => _errorMessage = 'অভিযোগের কারণ ও বিবরণ দিন।');
      return;
    }

    final auth = context.read<AuthRepository>();
    final userId = auth.currentUser?.id ?? 'anonymous_reporter';

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await context.read<InteractionRepository>().submitReport(
            reporterUserId: userId,
            targetType: widget.targetType,
            targetId: widget.targetId,
            category: _category,
            description: desc,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('আপনার অভিযোগটি পর্যালোচনার জন্য জমা হয়েছে। ধন্যবাদ!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.report_problem_rounded, color: AppColors.error),
          const SizedBox(width: 8),
          Text('রিপোর্ট করুন (Report Abuse)', style: AppTextStyles.headingSmall),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'এই বিজ্ঞাপনে কী সমস্যা রয়েছে তা নির্বাচন করুন:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ReportCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'অভিযোগের ধরন'),
              items: ReportCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat.labelBn, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (val) => setState(() => _category = val ?? ReportCategory.other),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _descController,
              label: 'বিস্তারিত বিবরণ লিখুন',
              hint: 'যেমন: ছবিতে দেওয়া ফ্ল্যাট বাস্তবে নেই, অগ্রিম টাকা চাওয়া হচ্ছে...',
              maxLines: 3,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('বাতিল'),
        ),
        AppButton(
          label: 'জমা দিন',
          isLoading: _isSubmitting,
          color: AppColors.error,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}

