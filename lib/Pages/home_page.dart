import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:salam_pakistan_new/Widget/custom_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  double _event1Opacity = 0.0;
  double _event2Opacity = 0.0;
  double _teamOpacity = 0.0;
  Map<String, dynamic>? _applicationDetails;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double event1Offset = 100; // Adjust these offsets as needed
    double event2Offset = 200;
    double teamOffset = 300;

    setState(() {
      _event1Opacity = _scrollController.offset > event1Offset ? 1.0 : 0.8;
      _event2Opacity = _scrollController.offset > event2Offset ? 1.0 : 0.7;
      _teamOpacity = _scrollController.offset > teamOffset ? 1.0 : 0.6;
    });
  }

  Future<void> _searchApplication() async {
    final serialNumber = _searchController.text.trim();

    if (serialNumber.isNotEmpty) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('applications')
            .where('serialNumber', isEqualTo: serialNumber)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            _applicationDetails = snapshot.docs.first.data();
          });
        } else {
          setState(() {
            _applicationDetails = null;
          });
          Get.snackbar(
            "No Results",
            "No application found with Serial Number $serialNumber",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to fetch application: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and Organization Name
                      Row(
                        children: [
                          Image.asset(
                            'images/logo.png',
                            color: Colors.white, // Your logo path
                            height: 100,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    'Salam Pakistan Organization',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Text(
                        'Presents',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Seerat Un Nabi Debating Competition 2024',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const AnimatedApplyButton(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Application',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Enter Serial Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _searchApplication,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _applicationDetails != null
                      ? Receipt(_applicationDetails!)
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  const Text(
                    'Organization Highlights',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _event1Opacity,
                    child: _buildEvent(
                      context,
                      'Salam Pakistan Debating Writing and Painting Competition 2010',
                      'This competition was held at the school level, encouraging youth to express their talents in debating, writing, and painting. It was a significant success, with numerous participants showcasing their creativity and oratory skills. This event played a crucial role in fostering a sense of confidence and enthusiasm among young students, many of whom went on to achieve great success in their respective fields.',
                      'images/event_1.jpg',
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _event2Opacity,
                    child: _buildEvent(
                      context,
                      'Salam Pakistan Azadi Show 2016',
                      'Held on Pakistan\'s Independence Day, the Salam Pakistan Azadi Show 2016 was a grand celebration of the nation’s freedom. This event became the largest gathering in the history of Dokota and Tehsil Mailsi, bringing together people from all walks of life. The show featured performances, speeches, and cultural displays that captured the spirit of patriotism and unity.',
                      'images/event_2.jpg',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _teamOpacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeamMember(
                          'images/ashfaq_sb.jpg',
                          'Ahmad Ashfaq Sehar',
                          'Event Coordinator',
                        ),
                        _buildTeamMember(
                          'images/iqbal_javed.jpg',
                          'Iqbal Javed',
                          'Event Director',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvent(BuildContext context, String title, String description,
      String imagePath) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String imagePath, String name, String designation) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        Text(
          designation,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget Receipt(Map<String, dynamic> applicationDetails) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal:
            MediaQuery.of(context).size.width * 0.05, // Responsive padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SALAM PAKISTAN ORGANIZATION DOKOTA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width *
                            0.009, // Responsive font size
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Salam Pakistan Organization Dokota is committed to fostering the educational and cultural growth of youth through various programs, competitions, and events. Our mission is to inspire, educate, and empower students to excel in their academic and extracurricular pursuits.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *
                            0.009, // Responsive font size
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Competition: Seerat Un Nabi (SAW) Debating Competition 2024",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width *
                            0.009, // Responsive font size
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.003), // Responsive spacing
              Expanded(
                  flex: 1,
                  child: CachedNetworkImage(
                    imageUrl: applicationDetails['imageUrl'],
                    fit: BoxFit.fitHeight,
                    height: 150,
                  )),
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // Responsive spacing
          const Divider(color: Colors.grey, thickness: 1.5),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // Responsive spacing

          // Applicant Details Section
          _buildApplicantDetails(applicationDetails),

          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.03), // Responsive spacing
          const Divider(color: Colors.grey, thickness: 1.5),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // Responsive spacing

          // Signature Section
          _buildSignatureSection(),

          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.03), // Responsive spacing
          const Divider(color: Colors.grey, thickness: 1.5),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // Responsive spacing

          // Footer Section
          _buildFooter(),
        ],
      ),
    );
  }

  String _calculateAge(String dob) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(dob);
    DateTime today = DateTime.now();
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    return "$years years, $months months";
  }

  Widget _buildApplicantDetails(Map<String, dynamic> applicationDetails) {
    String dob = applicationDetails['dateOfBirth'] ?? 'N/A';
    String age = dob != 'N/A' ? _calculateAge(dob) : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Serial No', applicationDetails['serialNumber']),
            ),
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Eligibilty',
                  applicationDetails['isEligible']
                      ? "Congrats! You are Eligible"
                      : "Alas! you are not Eligible"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child:
                  _buildDetailItem('Name', applicationDetails['applicantName']),
            ),
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Father Name', applicationDetails['fatherName']),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Date of Birth', applicationDetails['dateOfBirth']),
            ),
            Expanded(
              flex: 1,
              child: _buildDetailItem('Age', age),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child:
                  _buildDetailItem('Class', applicationDetails['studentClass']),
            ),
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'School/College', applicationDetails['schoolCollege']),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child:
                  _buildDetailItem('Category', applicationDetails['category']),
            ),
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Contact Number 1', applicationDetails['contactNumber1']),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildDetailItem(
                  'Contact Number 2', applicationDetails['contactNumber2']),
            ),
            Expanded(
                flex: 1,
                child:
                    _buildDetailItem('Address', applicationDetails['address'])),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text(
              "Signature (Authorities)",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: 150,
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "Signature (Authorities)",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: 150,
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Important Notice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "This receipt must be stamped during both the audition and the final competition. Please ensure its safekeeping, as it is a critical document for your participation in the event.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "This receipt has been issued by Salam Pakistan Organization Dokota.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "For further information or inquiries, please contact:",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Phone: +92 302 743 9724",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Phone: +92 300 773 3764",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
