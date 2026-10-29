import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/app_store.dart';
import '../database/profile_store.dart';
import '../theme/app_theme.dart';
import '../widgets/form_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pick(BuildContext context, ImageSource src) async {
    try {
      final x = await ImagePicker().pickImage(
          source: src, maxWidth: 512, maxHeight: 512, imageQuality: 70);
      if (x == null) return;
      await ProfileStore.instance.setPhoto(await x.readAsBytes());
    } catch (_) {
      if (context.mounted) _snack(context, 'Could not load the image');
    }
  }

  void _photoSheet(BuildContext context) {
    final hasPhoto = ProfileStore.instance.photo != null;
    showModalBottomSheet(
      context: context,
      builder: (sheet) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(sheet);
              _pick(context, ImageSource.gallery);
            },
          ),
          if (!kIsWeb)
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(sheet);
                _pick(context, ImageSource.camera);
              },
            ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: const Text('Remove photo',
                  style: TextStyle(color: AppColors.red)),
              onTap: () {
                Navigator.pop(sheet);
                ProfileStore.instance.setPhoto(null);
              },
            ),
        ]),
      ),
    );
  }

  Future<void> _editName(BuildContext context) async {
    final c = TextEditingController(text: ProfileStore.instance.name);
    final v = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (v != null && v.isNotEmpty) ProfileStore.instance.setName(v);
  }

  Future<void> _clear(BuildContext context) async {
    if (!await confirmDialog(context, 'Clear storage',
        'All transactions and credits will be deleted.')) return;
    await AppStore.instance.clearAll();
    if (context.mounted) _snack(context, 'Storage cleared');
  }

  @override
  Widget build(BuildContext context) {
    final p = ProfileStore.instance;
    return Scaffold(
      appBar: tealAppBar('Profile'),
      body: LayoutBuilder(
        builder: (_, box) {
          final radius = (box.maxWidth * 0.13).clamp(40.0, 64.0);
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight),
              child: Center(
                child: ListenableBuilder(
                  listenable: p,
                  builder: (_, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _photoSheet(context),
                        child: Stack(children: [
                          CircleAvatar(
                            radius: radius,
                            backgroundColor: const Color(0xFFD0D0D0),
                            backgroundImage:
                                p.photo == null ? null : MemoryImage(p.photo!),
                            child: p.photo == null
                                ? Icon(Icons.person,
                                    size: radius, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.camera_alt,
                                  size: 13, color: Colors.white),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                            child: Text(p.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          IconButton(
                              onPressed: () => _editName(context),
                              icon: const Icon(Icons.edit,
                                  size: 14, color: AppColors.grey)),
                        ]),
                      ),
                      if (p.photo != null)
                        TextButton(
                          onPressed: () => p.setPhoto(null),
                          child: const Text('Remove photo',
                              style: TextStyle(fontSize: 11, color: AppColors.red)),
                        ),
                      OutlinedButton(
                        onPressed: () => _clear(context),
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            foregroundColor: AppColors.grey,
                            side: const BorderSide(color: AppColors.border)),
                        child: const Text('Clear Storage',
                            style: TextStyle(fontSize: 11)),
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
  }
}
