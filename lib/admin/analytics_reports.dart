import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsReports extends StatefulWidget {
  const AnalyticsReports({super.key});

  @override
  State<AnalyticsReports> createState() => _AnalyticsReportsState();
}

class _AnalyticsReportsState extends State<AnalyticsReports> {
  int users = 0;
  int courses = 0;
  int quizzes = 0;
  int contents = 0;

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    final usersSnap = await FirebaseFirestore.instance
        .collection('users')
        .get();

    final coursesSnap = await FirebaseFirestore.instance
        .collection('courses')
        .get();

    final quizzesSnap = await FirebaseFirestore.instance
        .collection('quizzes')
        .get();

    final contentSnap = await FirebaseFirestore.instance
        .collection('course_content')
        .get();

    setState(() {
      users = usersSnap.docs.length;
      courses = coursesSnap.docs.length;
      quizzes = quizzesSnap.docs.length;
      contents = contentSnap.docs.length;
    });
  }

  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 34),
          ),

          const SizedBox(width: 18),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Platform Overview",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Users, courses, quizzes and uploaded content",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 320,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (users + 5).toDouble(),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                ),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Users"),
                            );

                          case 1:
                            return const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Courses"),
                            );

                          case 2:
                            return const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Quizzes"),
                            );

                          case 3:
                            return const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text("Content"),
                            );
                        }

                        return const Text('');
                      },
                    ),
                  ),
                ),

                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: users.toDouble(),
                        width: 28,
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                        ),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: courses.toDouble(),
                        width: 28,
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9F43), Color(0xFFFFC371)],
                        ),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: quizzes.toDouble(),
                        width: 28,
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
                        ),
                      ),
                    ],
                  ),

                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: contents.toDouble(),
                        width: 28,
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C9A7), Color(0xFF92FE9D)],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B7FFF), Color(0xFF39D2C0)],
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Analytics & Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Monitor your platform statistics",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    // TOP CARDS
                    Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            "Total Users",
                            users.toString(),
                            Icons.people,
                            const Color(0xFF5B7FFF),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: buildStatCard(
                            "Courses",
                            courses.toString(),
                            Icons.menu_book,
                            const Color(0xFFFF9F43),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            "Quizzes",
                            quizzes.toString(),
                            Icons.quiz,
                            const Color(0xFFFC5C7D),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: buildStatCard(
                            "Contents",
                            contents.toString(),
                            Icons.video_library,
                            const Color(0xFF00C9A7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // CHART
                    buildChart(),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}