import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_state/state.dart';

import '../data/models/product.dart';
import '../providers/product_crud_notifier.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final crud = ref.watch(productCrudProvider);
    final notifier = ref.read(productCrudProvider.notifier);

    final key = ActionKey(ActionType.create);
    final action = crud.get(key.value);
    final isSaving = action.isLoading;
    _listenForActions(key);

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'السعر'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () {
                      notifier.create(
                        Product(
                          id: 1,
                          title: _titleCtrl.text,
                          description: _descCtrl.text,
                          price: double.parse(_priceCtrl.text),
                        ),
                      );
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _listenForActions(ActionKey key){
    listenForActions(
      ref: ref,
      provider: productCrudProvider,
      reactions: {
        ActionKey(ActionType.create): ActionReaction(
          onSuccess: () {
            Navigator.pop(context);
            ref.read(productCrudProvider.notifier).clear(key.value);
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.message)));
            ref.read(productCrudProvider.notifier).clear(key.value);
          },
        ),
      },
    );
  }
}
