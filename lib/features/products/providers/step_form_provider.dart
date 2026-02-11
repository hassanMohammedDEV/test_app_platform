import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import 'product_form_provider.dart';

final stepFormProvider =
StateNotifierProvider<
    StepFormNotifier<ProductField>,
    StepFormState>((ref) {
  final formNotifier =
  ref.read(productFormProvider.notifier);

  return StepFormNotifier<ProductField>(
    formNotifier: formNotifier,
    stepFields: {
      0: [
        ProductField.title,
        ProductField.price,
      ],
      1: [
        ProductField.description,
      ],
    },
  );
});

/// Example for use it
// class ProductStepperPage extends ConsumerWidget {
//   const ProductStepperPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final formNotifier =
//     ref.read(productFormProvider.notifier);
//
//     final stepState =
//     ref.watch(stepFormProvider);
//
//     final stepNotifier =
//     ref.read(stepFormProvider.notifier);
//
//     final currentStep =
//         stepState.currentStep;
//
//     final form =
//     ref.watch(productFormProvider);
//
//     return Scaffold(
//       appBar:
//       AppBar(title: const Text('Add Product')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// 🧩 STEP CONTENT باستخدام switch
//             switch (currentStep) {
//               0 => Column(
//                 children: [
//                   _titleField(ref),
//                   const SizedBox(height: 12),
//                   _priceField(ref),
//                 ],
//               ),
//
//               1 => Column(
//                 children: [
//                   _descriptionField(ref),
//                 ],
//               ),
//
//               _ => const SizedBox(),
//             },
//
//             const SizedBox(height: 24),
//
//             /// 🔘 BUTTONS
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 if (currentStep > 0)
//                   ElevatedButton(
//                     onPressed:
//                     stepNotifier.back,
//                     child:
//                     const Text('Back'),
//                   ),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     final isLastStep =
//                         currentStep == 1;
//
//                     if (isLastStep) {
//                       formNotifier.validateAll();
//
//                       if (!form.isValid) return;
//
//                       final product = {
//                         'title': form
//                             .field<String>(
//                             ProductField.title)
//                             .value,
//                         'price': form
//                             .field<String>(
//                             ProductField.price)
//                             .value,
//                         'description': form
//                             .field<String>(
//                             ProductField
//                                 .description)
//                             .value,
//                       };
//
//                       debugPrint(
//                           'SUBMIT: $product');
//                     } else {
//                       stepNotifier.next();
//                     }
//                   },
//                   child: Text(
//                     currentStep == 1
//                         ? 'Submit'
//                         : 'Next',
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


