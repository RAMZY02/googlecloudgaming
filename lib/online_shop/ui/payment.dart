import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midtrans_plugin/midtrans_plugin.dart'; // Make sure to import Midtrans plugin if using it
import 'package:midtrans_plugin/models/midtrans_payload.dart';
import '../controller/payment_controller.dart';  // Make sure to import the PaymentController if needed
import '../models/payment.dart';  // Import the Payment model

class PaymentPage extends StatefulWidget {
  final String paymentUrl;  // The URL for payment
  final String orderId;     // The order ID for the transaction
  final double totalAmount; // The total amount for the payment

  PaymentPage({
    required this.paymentUrl,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isProcessing = false;

  // Start Midtrans transaction using the payment URL passed
  Future<void> _startMidtransTransaction() async {
    try {
      setState(() {
        isProcessing = true;
      });

      // final result = await MidtransPlugin.startPaymentUi(
      //   token: widget.paymentUrl, // This should be the actual Midtrans token, not the URL
      // );
      //
      // // Log the result for debugging
      // print('Midtrans Payment Result: $result');
      //
      // // Handle the result from Midtrans
      // if (result['transaction_status'] == 'capture' || result['transaction_status'] == 'settlement') {
      //   _showPaymentStatus('Payment Successful', 'Your payment was successful. Order ID: ${widget.orderId}');
      // } else if (result['transaction_status'] == 'pending') {
      //   _showPaymentStatus('Payment Pending', 'Your payment is pending. Order ID: ${widget.orderId}');
      // } else {
      //   _showPaymentStatus('Payment Failed', 'Your payment failed or was canceled. Order ID: ${widget.orderId}');
      // }
      //
      // await MidtransPlugin.instance.startPayment(
      //   MidtransPayload(
      //     transactionDetails: transactionDetails,
      //     itemDetails: itemDetails,
      //     customerDetails: customerDetails,
      //   ),
      // );
    } on PlatformException catch (e) {
      // Handle errors during Midtrans payment process
      print('Midtrans Payment Error: ${e.message}');
      _showPaymentStatus('Payment Error', 'Error: ${e.message}');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }


  // Show payment status dialog
  void _showPaymentStatus(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the previous page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: isProcessing
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while processing
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Order ID: ${widget.orderId}',  // Display the passed orderId
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount: Rp${widget.totalAmount.toStringAsFixed(0)}',  // Display the totalAmount
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing ? null : _startMidtransTransaction, // Disable button if processing
              child: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
