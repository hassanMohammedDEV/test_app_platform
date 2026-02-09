import 'package:app_platform_state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_pkg/features/products/data/models/models.dart';

import '../providers/product_crud_notifier.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() =>
      _AddProductDialogState();
}

class _AddProductDialogState
    extends ConsumerState<AddProductDialog> {

  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final crud = ref.watch(productCrudProvider);
    final notifier = ref.read(productCrudProvider.notifier);

    final key = ActionKey(ActionType.create);
    final action = crud.get(key.value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_submitted) return; // 🔴 الحل هنا

      if (!action.isLoading && action.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت الإضافة بنجاح')),
        );
        notifier.clear(key.value);
        Navigator.pop(context);
      }

      if (action.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(action.error!.message)),
        );
        notifier.clear(key.value);
      }
    });

    return AlertDialog(
      title: const Text('إضافة منتج'),
      actions: [
        ElevatedButton(
          onPressed: action.isLoading
              ? null
              : () {
            _submitted = true; // 🔴 مهم
            notifier.create(Product(id: 1, title: 'title', description: 'description', price: 500));
          },
          child: action.isLoading
              ? const CircularProgressIndicator()
              : const Text('حفظ'),
        ),
      ],
    );
  }
}

