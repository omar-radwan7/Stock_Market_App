import 'package:flutter/material.dart';
import '../premium/premium.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement profile editing functionality
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4C336F), Color(0xFF170201), Color(0xFF0D1531)],
            stops: [0.0, 0.2, 1.0],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    // Profile Image
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        "https://placehold.co/113x117",
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    const Text(
                      'Omar Radwan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                        letterSpacing: 0.80,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Account Button
                    _buildProfileButton(context, 'Account'),
                    const SizedBox(height: 20),
                    // Settings Button
                    _buildProfileButton(context, 'Settings'),
                    const SizedBox(height: 20),
                    // Help Button
                    _buildProfileButton(context, 'Help'),
                    const SizedBox(height: 40),
                    // Premium Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Premiumpage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 294,
                        height: 46,
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(0.50, -0.00),
                            end: Alignment(0.50, 1.00),
                            colors: [
                              Color(0xFF071850),
                              Color(0xFF0B2783),
                              Color(0xFF0C1E59),
                              Color(0xFF0C1531),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Bar
              Positioned(
                left: 0,
                top: -10,
                child: Container(
                  width: 430,
                  height: 57.83,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 376,
                        top: 23,
                        child: Opacity(
                          opacity: 0.35,
                          child: Container(
                            width: 25,
                            height: 14,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(3.50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 378,
                        top: 25,
                        child: Container(
                          width: 21,
                          height: 10,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 76.33,
        decoration: ShapeDecoration(
          color: const Color(0xFF0C1531),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.60),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: 0.80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
