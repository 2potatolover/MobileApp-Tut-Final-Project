import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/purchased_products_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethod { cash, card }

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  final _voucherController = TextEditingController();
  double _discount = 0.0;

  void _applyVoucher() {
    if (_voucherController.text == 'juanisawesome') {
      setState(() {
        _discount = 0.67;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher applied! You get a 67% discount.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _discount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid voucher code.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalAmount = cart.totalAmount;
    final discountedTotal = totalAmount * (1 - _discount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: \$${discountedTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (_discount > 0)
              Text(
                'Original: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const SizedBox(height: 20),
            const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ToggleButtons(
              isSelected: [
                _paymentMethod == PaymentMethod.cash,
                _paymentMethod == PaymentMethod.card,
              ],
              onPressed: (index) {
                setState(() {
                  _paymentMethod = PaymentMethod.values[index];
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Cash'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Card'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _voucherController,
              decoration: InputDecoration(
                labelText: 'Voucher Code',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _applyVoucher,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Order Confirmed!'),
                      content: const Text('Your items have been ordered.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Provider.of<PurchasedProductsProvider>(context, listen: false).addPurchasedProducts(cart.items);
                            cart.clear();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('Confirm Order'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
