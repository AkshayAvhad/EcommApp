import 'package:ecomm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:ecomm/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:ecomm/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const .all(24.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: .center,
                    children: [
                      // User Avatar Image
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(user.image),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(fontSize: 24, fontWeight: .bold),
                      ),
                      const SizedBox(height: 8),

                      // Username Tag
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontStyle: .italic,
                        ),
                      ),
                      const Divider(height: 40, thickness: 1),

                      // Profile Info Details
                      _buildInfoTile(Icons.email, 'Email Address', user.email),
                      _buildInfoTile(Icons.person, 'Gender', user.gender),
                      _buildInfoTile(Icons.badge, 'User ID', '#${user.id}'),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('No profile data available.'));
          },
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: .symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: .w600)),
            ],
          ),
        ],
      ),
    );
  }
}
