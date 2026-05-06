// validation_provider.dart

import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:test_pkg/features/products/data/models/product_fields.dart';
import 'package:test_pkg/features/products/data/models/product_state_model.dart';
import 'package:test_pkg/features/products/providers/product_fields_notifier.dart';

final productValidationProvider =
NotifierProvider<
    ProductValidationNotifier,
    FormValidationState<ProductField>
>(
  ProductValidationNotifier.new,
);

class ProductValidationNotifier
    extends ValidationController<ProductField> {

  @override
  FormValidationState<ProductField> build() {

    init();

    return state;
  }

  // ================= VALIDATE TITLE =================

  void validateTitle(String? value) {

    String? error;

    if (value == null || value.isEmpty) {
      error = 'العنوان مطلوب';
    }

    setFieldValidation(
      ProductField.title,
      error: error,
    );
  }

  bool validateForm(ProductStateModel state) {

    validateTitle(state.title);

    return this.state.isValid;
  }
}