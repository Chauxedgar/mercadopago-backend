import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejemplo Mercado Pago Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PaymentHomeScreen(),
    );
  }
}

class PaymentHomeScreen extends StatefulWidget {
  const PaymentHomeScreen({super.key});

  @override
  State<PaymentHomeScreen> createState() => _PaymentHomeScreenState();
}

class _PaymentHomeScreenState extends State<PaymentHomeScreen> {
  bool _isLoading = false;

  // Función para conectarnos a nuestro backend en Node.js
  Future<void> _createPreferenceAndPay() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ⚠️ IMPORTANTE sobre la IP:
      // - Si usas Emulador de Android: usa 'http://10.0.2.2:3000/create_preference'
      // - Si usas un Dispositivo Físico por USB: usa la IP local de tu PC (ej: 'http://192.168.1.X:3000/create_preference')
      // - Si usas Simulador de iOS: usa 'http://localhost:3000/create_preference'
      const String urlBackend = 'http://localhost:3000/create_preference';

      final response = await http.post(
        Uri.parse(urlBackend),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Obtenemos el link de sandbox que nos devolvió Node.js
        final String sandboxInitPoint = data['sandbox_init_point'];
       

        final Uri paymentUri = Uri.parse(sandboxInitPoint);

        // Abrimos el navegador con la pasarela de pago de Mercado Pago
        if (await canLaunchUrl(paymentUri)) {
          await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir el enlace de pago: $sandboxInitPoint';
        }
      } else {
        _showErrorDialog('Error del servidor al crear la preferencia.');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: $e. Revisa que tu backend esté encendido y la IP sea correcta.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Atención'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Pago - Mercado Pago'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_checkout, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Producto de Prueba Universitario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Precio: \$50,000 COP',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _createPreferenceAndPay,
                      icon: const Icon(Icons.payment),
                      label: const Text('Pagar con Mercado Pago', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}