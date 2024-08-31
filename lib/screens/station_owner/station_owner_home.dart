import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Station Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _stationAvailable = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchRole() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switched Role')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'EV Station Dashboard',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(height: 20),
                    _buildStationAvailabilityCard(),
                    SizedBox(height: 20),
                    _buildTodaysCustomersCard(),
                    SizedBox(height: 20),
                    _buildRevenueDashboardCard(),
                    SizedBox(height: 20),
                    _buildWeeklyEarningsCard(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: FloatingActionButton(
                onPressed: _switchRole,
                backgroundColor: Colors.blue,
                child: Icon(Icons.swap_horiz, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationAvailabilityCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Station Availability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _stationAvailable,
              onChanged: (value) {
                setState(() {
                  _stationAvailable = value;
                });
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysCustomersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueDashboardCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RevenueDashboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyEarningsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Earnings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: WeeklyEarningsGraph(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customers = [
      {'name': 'John Doe', 'vehicle': 'Tesla Model 3'},
      {'name': 'Jane Smith', 'vehicle': 'Nissan Leaf'},
      {'name': 'Bob Johnson', 'vehicle': 'Chevrolet Bolt'},
    ];

    return Column(
      children: customers
          .map((customer) => ListTile(
                title: Text(customer['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(customer['vehicle']!),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.electric_car, color: Colors.blue[800]),
                ),
              ))
          .toList(),
    );
  }
}

class RevenueDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRevenueItem('Today\'s Revenue', '\$250.00'),
        SizedBox(height: 10),
        _buildRevenueItem('This Week', '\$1,750.00'),
      ],
    );
  }

  Widget _buildRevenueItem(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Text(
          amount,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }
}

class WeeklyEarningsGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 50,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'MON',
                      'TUE',
                      'WED',
                      'THU',
                      'FRI',
                      'SAT',
                      'SUN'
                    ];
                    final index = value.toInt();
                    if (index >= 0 && index < days.length) {
                      return Text(days[index],
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold));
                    }
                    return Text('');
                  },
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text('\$${value.toInt()}',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold));
                  },
                  interval: 50,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 300,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 200),
                  FlSpot(1, 150),
                  FlSpot(2, 250),
                  FlSpot(3, 180),
                  FlSpot(4, 220),
                  FlSpot(5, 190),
                  FlSpot(6, 280),
                ],
                isCurved: true,
                color: Colors.blue[600],
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue[200]!.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
