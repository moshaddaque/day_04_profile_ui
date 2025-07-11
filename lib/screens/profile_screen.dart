import 'dart:io';

import 'package:day_04_profile_ui/widgets/action_buttons.dart';
import 'package:day_04_profile_ui/widgets/header_section.dart';
import 'package:day_04_profile_ui/widgets/profile_avater_section.dart';
import 'package:day_04_profile_ui/widgets/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // variables
  File? _profileImage;
  bool _isEditing = false;
  bool _isLoading = false;

  // animation controllers
  late AnimationController _avaterAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _fadeAnimation;

  // IMAGE PICKER INSTANCE
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  // initialize animations
  void _initializeAnimations() {
    _avaterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    );
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    // avater animation
    _avatarScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _avaterAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  // load initial data
  Future<void> _loadInitialData() async {
    // basic given data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@gmail.com';
    _bioController.text =
        'Flutter Developer passionate about creating beautiful mobile experiences.';
  }

  // image picker function

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        _avaterAnimationController.forward().then((_) {
          _avaterAnimationController.reverse();
        });

        // Haptic FeedBack
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image : $e');
    }
  }

  // remove image
  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
    _avaterAnimationController.forward().then((_) {
      _avaterAnimationController.reverse();
    });
    HapticFeedback.lightImpact();
  }

  // save profile image
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // simulate ipi call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    _showSuccessSnackBar('Profile saved successfully');
    HapticFeedback.lightImpact();
  }

  //=============== ui ===========================

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[50],

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : 20,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header Section
                    HeaderSection(
                      isEditing: _isEditing,
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                    const SizedBox(height: 40),

                    // profile avater section
                    ProfileAvatarSection(
                      scaleAnimation: _avatarScaleAnimation,
                      isEditing: _isEditing,
                      profileImage: _profileImage,
                      removeImage: _removeImage,
                      pickImage: _pickImage,
                    ),

                    // _buildProfileAvatar(),
                    const SizedBox(height: 30),

                    // profile form
                    ProfileForm(
                      nameController: _nameController,
                      emailController: _emailController,
                      bioController: _bioController,
                    ),

                    const SizedBox(height: 40),
                    // save button
                    ActionButtons(
                      isEditing: _isEditing,
                      isLoading: _isLoading,
                      saveProfile: _isLoading ? null : _saveProfile,
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      editProfile: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // snackBars

  //error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // dispose every controllers

  @override
  void dispose() {
    _avaterAnimationController.dispose();
    _fadeAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  //---------------------------------------------

  Widget _buildProfileAvatar() {
    return Hero(
      tag: 'profile-avatar',
      child: GestureDetector(
        onTap: _isEditing ? _pickImage : null,
        child: AnimatedBuilder(
          animation: _avatarScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _avatarScaleAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            _profileImage != null
                                ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                )
                                : _buildDefaultAvatar(),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    if (_profileImage != null && _isEditing)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
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
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 50),
    );
  }
}
