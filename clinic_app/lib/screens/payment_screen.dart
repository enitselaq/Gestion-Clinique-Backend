import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String patientName;

  const PaymentScreen({super.key, required this.amount, required this.patientName});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Paiement Sécurisé'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryTeal, AppTheme.deepTeal]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total à régler', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('${widget.amount.toStringAsFixed(2)} MAD', 
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white24, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service: Consultation', style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text(widget.patientName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            const Text('Informations de la carte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            _buildTextField('Nom sur la carte', 'Ex: Mohammed Alami', Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Numéro de carte', 'XXXX XXXX XXXX XXXX', Icons.credit_card, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('Expiration', 'MM/AA', Icons.calendar_today, keyboardType: TextInputType.datetime)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('CVV', 'XXX', Icons.lock_outline, keyboardType: TextInputType.number, obscureText: true)),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Decorative Security Badge
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text('Paiement sécurisé SSL 128-bit', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTeal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isProcessing ? null : () async {
                  setState(() => _isProcessing = true);
                  // Simulate processing
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) Navigator.pop(context, true);
                },
                child: _isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Payer ${widget.amount.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 20),
            Center(
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png',
                height: 30,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.payment, size: 30, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.mutedSlate)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2)),
          ),
        ),
      ],
    );
  }
}
