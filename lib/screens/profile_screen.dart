import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:teaseme_flutter/constants/app_constants.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/utils/validators.dart';
import 'package:teaseme_flutter/widgets/consent_checkbox.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _stageNameController = TextEditingController();
  final _bioController = TextEditingController();
  PlatformFile? _profilePhoto;
  PlatformFile? _idDocument;
  List<String> _tags = [];
  bool _consent = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _stageNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Build Your Sexy Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Make it irresistible…',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name (private) *'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stageNameController,
                decoration: const InputDecoration(labelText: 'Stage Name (public) *'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio (max 500 chars)'),
                maxLines: 4,
                validator: (value) => Validators.maxLengthValidator(500, value),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(_profilePhoto == null ? 'Profile Photo (JPG/PNG) *' : _profilePhoto!.name),
                trailing: const Icon(Icons.upload),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(allowedExtensions: ['jpg', 'jpeg', 'png']);
                  if (result != null) setState(() => _profilePhoto = result.files.first);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(_idDocument == null ? 'ID Document (PDF/JPG) *' : _idDocument!.name),
                trailing: const Icon(Icons.upload),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
                  if (result != null) setState(() => _idDocument = result.files.first);
                },
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Your Vibe *'),
                child: Wrap(
                  spacing: 8,
                  children: AppConstants.contentTags.map((tag) => ChoiceChip(
                        label: Text(tag),
                        selected: _tags.contains(tag),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _tags.add(tag);
                            } else {
                              _tags.remove(tag);
                            }
                          });
                        },
                      )).toList(),
                ),
              ),
              const SizedBox(height: 20),
              ConsentCheckbox(
                value: _consent,
                onChanged: (value) => setState(() => _consent = value!),
                title: const Text('I consent to data processing (POPIA)'),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save & Go Live!',
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _consent && _profilePhoto != null && _idDocument != null && _tags.isNotEmpty) {
                    try {
                      final photoUrl = _profilePhoto != null ? 'uploaded_photo_url' : null;
                      final idUrl = _idDocument != null ? 'uploaded_id_url' : null;
                      await ApiService().post('/api/teasers/create/', {
                        'full_name': _fullNameController.text,
                        'stage_name': _stageNameController.text,
                        'bio': _bioController.text,
                        'profile_photo': photoUrl,
                        'id_document': idUrl,
                        'tags': _tags,
                        'consent': _consent,
                      });
                      Navigator.pushReplacementNamed(context, '/dashboard/teaser');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile creation failed: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please complete all fields and consent')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}