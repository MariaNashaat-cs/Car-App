import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'confirmation.dart'; 

class RentalDetailScreen extends StatefulWidget {
  final String carModel;
  final String carImage;
  final int price;

  const RentalDetailScreen({
    super.key,
    required this.carModel,
    required this.carImage,
    required this.price,
  });

  @override
  _RentalDetailScreenState createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  final _addressController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _addressController.text = '3891 Ranchview Dr. Richardson, California';
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 2));
    _selectedPaymentMethod = 'Credit Card';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDate = newDateTime;
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _selectPaymentMethod(BuildContext context) async {
    final List<String> paymentMethods = ['Credit Card', 'Cash'];
    final String? selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Payment Method'),
        children: paymentMethods
            .map((method) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, method),
                  child: Text(method),
                ))
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedPaymentMethod = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = _endDate?.difference(_startDate ?? DateTime.now()).inDays ?? 2;
    final totalPrice = widget.price * duration;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rent Detail',
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
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        widget.carImage,
                        height: 60,
                        width: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[200],
                            child: const Icon(Icons.directions_car, color: Colors.black),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.carModel,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.price} L.E per day',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter address',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rent Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDateTime(context, true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    _startDate == null
                                        ? 'Select Start'
                                        : DateFormat('MMM dd, yyyy HH:mm').format(_startDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _selectDateTime(context, false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    _endDate == null
                                        ? 'Select End'
                                        : DateFormat('MMM dd, yyyy HH:mm').format(_endDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Payment Method
                Row(
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _selectPaymentMethod(context),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.credit_card,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedPaymentMethod ?? 'Select Payment',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Price Detail
                const Text(
                  'Price Detail',
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
                    children: [
                      _buildPriceRow('Daily Rate', '${widget.price} L.E'),
                      const SizedBox(height: 12),
                      _buildPriceRow('Duration', '$duration days'),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _buildPriceRow('Total', '$totalPrice L.E', isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Bottom Button
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentalConfirmationScreen(
                            carModel: widget.carModel,
                            totalPrice: totalPrice,
                            duration: duration,
                            startDate: _startDate ?? DateTime.now(),
                            endDate: _endDate ?? DateTime.now().add(const Duration(days: 2)),
                            paymentMethod: _selectedPaymentMethod ?? 'Credit Card',
                            address: _addressController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Pay $totalPrice L.E',
                      style: const TextStyle(
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

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}