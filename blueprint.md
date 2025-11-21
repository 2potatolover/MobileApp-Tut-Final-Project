# E-Commerce App Blueprint

## Overview

This document outlines the features and design of the E-Commerce mobile application. The application allows users to browse products, add them to a cart, and checkout.

## Features

### 1. Product Catalog

- Displays a list of available products.
- Each product has a name, description, price, and image.
- Users can view product details by tapping on a product.

### 2. Shopping Cart

- Users can add products to a shopping cart.
- The cart displays the list of added products and the total amount.
- Users can remove products from the cart.

### 3. Checkout and Payment

- Users can proceed to checkout from the cart.
- The checkout screen displays the total amount and allows the user to select a payment method.
- Users can apply a voucher code to get a discount.
- A confirmation dialog is displayed after the order is placed.

### 4. Purchased Products

- A dedicated screen displays all the products that the user has purchased.

## Current Task: Fix Checkout Screen Deprecation Warnings

**Objective:** Resolve the deprecation warnings related to the `Radio` and `RadioListTile` widgets in the `checkout_screen.dart` file.

**Plan:**

1.  ~~Attempt to fix the `Radio` and `RadioListTile` widgets by using the `Radio.adaptive` constructor.~~ (Failed)
2.  ~~Attempt to create a custom `RadioGroup` widget to encapsulate the radio button logic.~~ (Failed due to Flutter version limitations)
3.  **[Current Solution]** Replace the `Radio` widgets with the `ToggleButtons` widget to provide a similar user experience and avoid deprecation warnings.
4.  Remove the unused `radio_group.dart` file.

**Changes:**

- Modified `lib/screens/checkout/checkout_screen.dart` to replace the `RadioListTile` widgets with a `ToggleButtons` widget for payment method selection.
- Deleted the `lib/widgets/radio_group.dart` file.
