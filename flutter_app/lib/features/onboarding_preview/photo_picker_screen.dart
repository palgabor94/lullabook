import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/preview_repository.dart';

class PhotoPickerScreen extends ConsumerStatefulWidget {
  const PhotoPickerScreen({
    super.key,
    required this.childName,
    required this.adventureChoice,
    required this.artStyle,
  });

  final String childName;
  final String adventureChoice;
  final String artStyle;

  @override
  ConsumerState<PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends ConsumerState<PhotoPickerScreen> {
  File? _photo;
  bool _loading = false;
  final _picker = ImagePicker();

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _generate() async {
    if (_photo == null) return;
    setState(() => _loading = true);

    try {
      final result = await ref.read(previewRepositoryProvider).generatePreview(
            childName: widget.childName,
            adventureChoice: widget.adventureChoice,
            artStyle: widget.artStyle,
            photoFile: _photo!,
          );

      if (mounted) {
        context.pushReplacement('/preview/reveal', extra: result);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text("${widget.childName}'s photo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Add a clear photo of your child\'s face.\nThis will become their storybook hero!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => _pickPhoto(ImageSource.gallery),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primary.withAlpha(80), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary.withAlpha(10),
                ),
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(_photo!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 48, color: AppColors.primary),
                          SizedBox(height: 12),
                          Text('Tap to choose from gallery',
                              style: TextStyle(color: AppColors.primary)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _pickPhoto(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Take a photo'),
            ),
            const Spacer(),
            if (_loading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Creating your hero… ~40 seconds',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              )
            else
              FilledButton(
                onPressed: _photo != null ? _generate : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Create my hero!',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
