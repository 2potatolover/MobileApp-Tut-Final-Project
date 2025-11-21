
// lib/screens/product_details/product_details_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/purchased_products_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  late List<Review> _reviews;
  bool _hasReviewed = false;

  @override
  void initState() {
    super.initState();
    _reviews = _generateRandomReviews();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showReviewDialog() {
    if (_hasReviewed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Already Reviewed'),
          content: const Text('You have already submitted a review for this product.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    int rating = 3;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return StarRating(rating: rating, onRatingChanged: (newRating) => setState(() => rating = newRating));
              },
            ),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _reviews.insert(
                  0,
                  Review(rating: rating, reviewer: 'You', comment: commentController.text),
                );
                _hasReviewed = true;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPurchased = Provider.of<PurchasedProductsProvider>(context).hasPurchased(widget.product.id);
    final double averageRating = _calculateAverageRating(_reviews);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.asset(
                widget.product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                widget.product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            if (hasPurchased)
              ElevatedButton(
                onPressed: _showReviewDialog,
                child: const Text('Write a Review'),
              ),
            const SizedBox(height: 20),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Average Rating: ${averageRating.toStringAsFixed(1)} (${_reviews.length} reviews)',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(review.rating.toString()),
                    ),
                    title: Text(review.reviewer),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StarRating(rating: review.rating),
                        Text(review.comment),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CartProvider>(context, listen: false).addItem(widget.product, _quantity);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added $_quantity item(s) to cart!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  List<Review> _generateRandomReviews() {
    final Random random = Random();
    final List<String> reviewers = ['Juan', 'Pedro', 'Maria', 'Jose', 'Ana', 'Luis', 'Sofia', 'Carlos', 'Laura', 'Miguel', 'Valeria', 'Diego', 'Camila', 'Javier', 'Isabella'];
    final List<String> comments = [
      'This product is amazing!',
      'Great value for the price.',
      'It\'s okay, but not the best.',
      'I wouldn\'t recommend it.',
      'Terrible, do not buy!',
      'I love it!',
      'Could be better.',
      'Not bad for the price.',
      'Five stars!',
      'Absolutely fantastic!',
    ];

    return List.generate(35, (index) {
      return Review(
        rating: random.nextInt(5) + 1,
        reviewer: reviewers[random.nextInt(reviewers.length)],
        comment: comments[random.nextInt(comments.length)],
      );
    });
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }
    final double totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
}

class Review {
  final int rating;
  final String reviewer;
  final String comment;

  Review({required this.rating, required this.reviewer, required this.comment});
}

class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({super.key, required this.rating, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            if (onRatingChanged != null) {
              onRatingChanged!(index + 1);
            }
          },
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}
