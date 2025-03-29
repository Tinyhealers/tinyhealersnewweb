import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String name = "";
  String degree = "";
  int experience = 0;
  String phoneNumber = "";
  String doctorId = "";
  bool isOnline = false; // Holds the online status
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load user details from SharedPreferences
    doctorId = prefs.getString('userId') ?? "N/A";
    name = prefs.getString('userName') ?? "Unknown";
    degree = prefs.getString('degree') ?? "Unknown";
    experience = prefs.getInt('experience') ?? 0;
    phoneNumber = prefs.getString('userPhone') ?? "N/A";

    // Fetch the latest online status from Supabase
    if (doctorId != "N/A") {
      await _fetchOnlineStatus();
    }

    setState(() {}); // Refresh UI after loading data
  }

  Future<void> _fetchOnlineStatus() async {
    try {
      final response = await supabase
          .from('doctors')
          .select('is_online')
          .eq('id', doctorId)
          .single();

      if (mounted) {
        setState(() {
          isOnline = response['is_online'] ?? false;
        });
      }
    } catch (e) {
      print("Error fetching online status: ${e.toString()}");
    }
  }

  void _updateOnlineStatus(bool value) async {
    if (doctorId.isEmpty || doctorId == "N/A") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Doctor ID!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update UI immediately for smooth UX
    setState(() {
      isOnline = value;
    });

    try {
      final response = await supabase
          .from('doctors')
          .update({'is_online': value})
          .match({'id': doctorId})
          .select('is_online')
          .single();

      if (response['is_online'] == value) {
        print("Successfully updated online status to: $value");
      } else {
        setState(() {
          isOnline = !value; // Revert on failure
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isOnline = !value; // Revert on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello $name,',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                'Welcome Back',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DoctorCard(
                doctorId: doctorId,
                name: name,
                phoneNumber: phoneNumber,
                degree: degree,
                experience: experience,
                isOnline: isOnline,
                onStatusChange: _updateOnlineStatus, // Pass callback
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DoctorCard Component
class DoctorCard extends StatelessWidget {
  final String doctorId;
  final String name;
  final String phoneNumber;
  final String degree;
  final int experience;
  final bool isOnline;
  final Function(bool) onStatusChange;

  const DoctorCard({
    Key? key,
    required this.doctorId,
    required this.name,
    required this.phoneNumber,
    required this.degree,
    required this.experience,
    required this.isOnline,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Switch(
                  value: isOnline,
                  onChanged: onStatusChange, // Call function from HomePage
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            Text(
              degree,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              '$experience years experience',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: isOnline ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: isOnline ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+91 $phoneNumber',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
