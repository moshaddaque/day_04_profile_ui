import 'package:day_04_profile_ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final bool isEditing;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.bioController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
          obscureText: false,
          isEditing: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            } else {
              return null;
            }
          },
        ),

        const SizedBox(height: 16),

        CustomTextField(
          controller: emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          obscureText: false,
          isEditing: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            } else if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(value)) {
              return 'Please enter a valid email address';
            } else {
              return null;
            }
          },
        ),

        const SizedBox(height: 16),

        CustomTextField(
          controller: bioController,
          label: 'Bio',
          isEditing: isEditing,
          icon: Icons.description_outlined,
          maxLines: 3,
          obscureText: false,
          validator: (value) {
            if (value == null && value!.length > 150) {
              return 'Bio cannot be more than 150 characters';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
