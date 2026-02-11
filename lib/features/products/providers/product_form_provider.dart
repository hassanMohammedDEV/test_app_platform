import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productFormProvider =
StateNotifierProvider.autoDispose<FormNotifier, FormStateModel>(
      (ref) {
    return FormNotifier(
      const FormStateModel(
        fields: {
          'title': FieldState<String>(value: ''),
          'description': FieldState<String>(value: ''),
          'price': FieldState<String>(value: ''),
        },
      ),
      validators: {
        'title': (value) =>
        value.isEmpty ? 'Title required' : null,
        'description': (value) =>
        value.isEmpty ? 'Description required' : null,
        'price': (value) =>
        value.isEmpty ? 'Price required' : null,
      },
    );
  },
);
