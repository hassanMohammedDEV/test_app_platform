// filters_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/products/data/models/product_fields.dart';
import 'package:test_pkg/features/products/data/models/product_state_model.dart';
import 'package:test_pkg/features/products/providers/product_validation_provider.dart';

final productFieldsProvider =
    NotifierProvider<ProductFieldsNotifier, ProductStateModel>(
      ProductFieldsNotifier.new,
    );

class ProductFieldsNotifier extends Notifier<ProductStateModel> {
  @override
  ProductStateModel build() {
    return ProductStateModel();
  }

  void setTitle(String value) {
    state = state.copyWith(title: value);

    ref.read(productValidationProvider.notifier).validateTitle(value);
  }

  // void setToDate(DateTime value) {
  //   state = state.copyWith(toDate: value);
  //
  //   ref.read(validationProvider.notifier).validate(ReportFields.toDate);
  // }
}
