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
        },
      ),
      validators: {
        ProductField.title: (v) =>
        v.isEmpty ? 'Title required' : null,
        ProductField.description: (v) =>
        v.isEmpty ? 'Description required' : null,
        ProductField.price: (v) =>
        v.isEmpty ? 'Price required' : null,
      },
    );
  },
);
