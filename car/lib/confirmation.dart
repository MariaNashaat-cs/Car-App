import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homepage.dart'; 

class RentalConfirmationScreen extends StatelessWidget {
  final String carModel;
  final int totalPrice;
  final int duration;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentMethod;
  final String address;

  const RentalConfirmationScreen({
    super.key,
    required this.carModel,
    required this.totalPrice,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rental Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Success Message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thank You for Renting!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your rental for $carModel has been successfully confirmed.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Rental Details
                const Text(
                  'Rental Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Car Model', carModel),
                      const SizedBox(height: 12),
                      _buildDetailRow('Total Price', '$totalPrice L.E'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Duration', '$duration days'),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Start Date',
                        DateFormat('MMM dd, yyyy HH:mm').format(startDate),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'End Date',
                        DateFormat('MMM dd, yyyy HH:mm').format(endDate),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Payment Method', paymentMethod),
                      const SizedBox(height: 12),
                      _buildDetailRow('Delivery Address', address),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Return Button
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to CarListingScreen and clear the navigation stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const CarListingScreen()),
                        (route) => false, // Remove all previous routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.normal,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}