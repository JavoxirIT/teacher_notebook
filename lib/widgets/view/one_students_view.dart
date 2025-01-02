import 'dart:convert';
import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OneStudentsView extends StatefulWidget {
  const OneStudentsView({super.key});

  @override
  State<OneStudentsView> createState() => _OneStudentsViewState();
}

class _OneStudentsViewState extends State<OneStudentsView> {
  late StudentDB _userData;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    _userData = setting.arguments as StudentDB;
    setState(() {});
    super.didChangeDependencies();
  }

  String dataPayStatus() {
    return _userData.studentPayStatus == 1 ? "Платно" : "Бесплатно";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: colorBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Profile Image
                  _userData.studentImg != ""
                      ? Image.memory(
                          const Base64Decoder().convert(_userData.studentImg!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: colorBlue,
                          child: Icon(
                            Icons.person,
                            size: 120,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Name overlay
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_userData.studentName} ${_userData.studentSurName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _userData.studentSecondName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .8),
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    RouteName.localSudentUpdate,
                    arguments: _userData,
                  );
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats Row
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        'Статус',
                        dataPayStatus(),
                        Icons.payments,
                      ),
                      _buildStatItem(
                        'Возраст',
                        _userData.studentBrithDay!,
                        Icons.cake,
                      ),
                      _buildStatItem(
                        'ID',
                        _userData.studentDocumentNomer!,
                        Icons.badge,
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: colorGrey200,
                ),

                // Info Cards
                _buildInfoCard(
                  'Контактная информация',
                  [
                    _buildInfoRow(
                        Icons.phone, 'Телефон', _userData.studentPhone),
                    _buildInfoRow(
                        Icons.location_on, 'Адрес', _userData.studentAddres!),
                  ],
                ),

                _buildInfoCard(
                  'Образование',
                  [
                    _buildInfoRow(
                      Icons.school,
                      'Учебное заведение',
                      _userData.studentSchoolAndClassNumber!,
                    ),
                  ],
                ),

                _buildInfoCard(
                  'Родители',
                  [
                    _buildInfoRow(
                      Icons.person,
                      'ФИО родителя',
                      _userData.studentParentsFio!,
                    ),
                    _buildInfoRow(
                      Icons.phone,
                      'Телефон родителя',
                      _userData.studentParentsPhone!,
                    ),
                  ],
                ),

                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: colorBlue, size: 24),
        const Gap(8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: colorGrey200,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: colorBlue, size: 20),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
