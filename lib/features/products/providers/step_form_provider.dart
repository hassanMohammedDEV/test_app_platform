import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_form_provider.dart';

final stepFormProvider =
StateNotifierProvider<StepFormNotifier,
    StepFormState>((ref) {
  final formNotifier =
  ref.read(productFormProvider.notifier);

  return StepFormNotifier(
    formNotifier: formNotifier,
    stepFields: {
      0: ['title', 'price'],
      1: ['description'],
      2: ['category'],
    },
  );
});

/// used in ui
/***
 final stepState = ref.watch(stepFormProvider);
    final stepNotifier =
    ref.read(stepFormProvider.notifier);

    int currentStep = stepState.currentStep;

    final field = form.field<String>('title');

    # in Button
    ElevatedButton(
    onPressed: stepNotifier.next,
    child: const Text('Next'),
    );
 * ***/

/// in fields
// Widget _titleField(
//     FormStateModel form,
//     FormNotifier notifier,
//     ) {
//   final field = form.field<String>('title');
//
//   return TextField(
//     onChanged: (value) {
//       notifier.update<String>(
//         name: 'title',
//         value: value,
//       );
//     },
//     decoration: InputDecoration(
//       labelText: 'Title',
//       errorText:
//       field.touched ? field.error : null,
//     ),
//   );
// }
