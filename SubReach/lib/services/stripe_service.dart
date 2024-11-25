import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();
  Map<String, dynamic>? data;
  String _baseUrl =
      "http://192.168.0.101:3000/api"; // Replace with your server URL

  Future<void> makePayment(context, amount) async {
    try {
      //STEP 1: Create a payment intent
      // paymentIntent = await createPaymentIntent(amount, 'usd');
      data = await _createPaymentIntent(amount);
      print(data?['client_secret']);
      Stripe.publishableKey =
          'pk_test_51PIwOLRxDoUeGEPbTICgMrGX6SUbULLKiFdiEvKBQvtgqA1RW1tvKgCTBAzlA7KceVhJRDoXRGLzwLenH56eFthu00mM4vvut3'; // Set your publishable key here
      print('Payment intent: ${data!['client_secret']}');
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data!['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          preferredNetworks: [CardBrand.Amex],
          // Customer params
          customerId: data!['customer'],
          customerEphemeralKeySecret: data!['ephemeralKey'],
          returnURL: 'flutterstripe://redirect',

          // Extra params
          primaryButtonLabel: 'Pay now',

          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'DE',
            testEnv: true,
            buttonType: PlatformButtonType.book,
          ),
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.lightBlue,
              primary: Colors.blue,
              componentBorder: Colors.red,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color.fromARGB(255, 231, 235, 30),
                  text: Color.fromARGB(255, 235, 92, 30),
                  border: Color.fromARGB(255, 235, 92, 30),
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      // Update step to 1
      // step = 1;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
    // await Stripe.instance
    //     .initPaymentSheet(
    //         paymentSheetParameters: SetupPaymentSheetParameters(
    //             paymentIntentClientSecret: paymentIntent!['client_secret'],
    //         //  E/flutter ( 1964): Your theme isn't set to use Theme.AppCompat or Theme.MaterialComponents.
    //             style: ThemeMode.dark,
    //             merchantDisplayName: 'Ikay'))
    //     .then((value) {});

    // //STEP 3: Display Payment sheet
    // displayPaymentSheet(context);
    // } catch (err) {
    //   throw Exception(err);
    // }
  }

  Future<void> displayPaymentSheet(context) async {
    print("Displaying payment sheet");
    try {
      var value = await Stripe.instance.presentPaymentSheet();
      // .then((value) {
      print('Payment sheet displayed' + value.toString());
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100.0,
                    ),
                    SizedBox(height: 10.0),
                    Text("Payment Successful!"),
                  ],
                ),
              ));

      data = null;
      // }).onError((error, stackTrace) {
      //   throw Exception(error);
      // });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error is:---> $e');
      print('$e');
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(String amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': (double.parse(amount) * 100).toInt(), // Convert to cents
          'currency': 'usd',
          'payment_method_types': ['card'],
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  final billingDetails = BillingDetails(
    name: 'Flutter Stripe',
    email: 'email@stripe.com',
    phone: '+48888000888',
    address: Address(
      city: 'Houston',
      country: 'US',
      line1: '1459  Circle Drive',
      line2: '',
      state: 'Texas',
      postalCode: '77063',
    ),
  ); // mocked data for tests

  // 2. initialize the payment sheet

  Future<void> confirmPayment(context) async {
    print('Confirming payment');
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      print('Payment sheet displayed');
      // setState(() {
      //   step = 0;
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }
}
