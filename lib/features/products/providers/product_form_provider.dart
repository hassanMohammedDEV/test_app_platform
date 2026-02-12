import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/products/data/models/product_fields.dart';

final productFormProvider =
StateNotifierProvider.autoDispose<
    FormNotifier<ProductField>,
    FormStateModel<ProductField>>(
      (ref) {
    return FormNotifier<ProductField>(
      FormStateModel<ProductField>(
        fields: {
          ProductField.title:
          const FieldState<String>(value: ''),
          ProductField.description:
          const FieldState<String>(value: ''),
          ProductField.price:
          const FieldState<String>(value: ''),
          ProductField.code:
          const FieldState<String>(value: ''),
          ProductField.website:
          const FieldState<String>(value: ''),
        },
      ),
      validators: {
        ProductField.title:
        Validators.combine([
          Validators.required(),
          Validators.minLength(3),
          Validators.maxLength(50),
        ]),

        ProductField.description:
        Validators.combine([
          Validators.required(),
          Validators.minLength(5),
        ]),

        ProductField.price:
        Validators.combine([
          Validators.required(),
          Validators.numeric(),
          Validators.range(min: 1, max: 100000),
        ]),

        ProductField.code:
            Validators.required(),

        ProductField.website:
            Validators.website(),

        // ProductField.email:
        // Validators.combine([
        //   Validators.required(),
        //   Validators.email(),
        // ]),

        // ProductField.website:
        // Validators.website(),
      },
      asyncValidators: {
        // Async check for email availability
        ProductField.code: (value) async {
          await Future.delayed(
              const Duration(milliseconds: 800));
          if (value == 'ewe') {
            return 'Code already exists';
          }
          return null;
        },
      },
    );
  },
);




