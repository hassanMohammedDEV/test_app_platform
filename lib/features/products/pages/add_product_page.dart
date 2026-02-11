import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_state/state.dart';

import '../data/models/product.dart';
import '../providers/providers.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    final crud = ref.watch(productCrudProvider);
    final notifier = ref.read(productCrudProvider.notifier);

    final key = ActionKey(ActionType.create);
    final action = crud.get(key.value);
    final isSaving = action.isLoading;

    // form
    final formNotifier = ref.read(productFormProvider.notifier);

    final titleField = ref.watch(
      productFormProvider.select((form) => form.field<String>('title')),
    );
    final decField = ref.watch(
      productFormProvider.select((form) => form.field<String>('description')),
    );
    final priceField = ref.watch(
      productFormProvider.select((form) => form.field<String>('price')),
    );

    _listenForActions(key);

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                formNotifier.update<String>(name: 'title', value: value);
              },
              decoration: InputDecoration(
                label: Text('العنوان'),
                errorText: titleField.touched ? titleField.error : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                formNotifier.update<String>(name: 'description', value: value);
              },
              decoration: InputDecoration(
                label: Text('الوصف'),
                errorText: decField.touched ? decField.error : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                formNotifier.update<String>(name: 'price', value: value);
              },
              decoration: InputDecoration(
                label: Text('السعر'),
                errorText: priceField.touched ? priceField.error : null,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () {
                      final form = ref.read(productFormProvider);
                      formNotifier.validateAll();
                      if (!form.isValid) return;

                      notifier.create(
                        Product(
                          id: 1,
                          title: form.field('title').value,
                          description: form.field('description').value,
                          price: double.parse(form.field('price').value),
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

  void _listenForActions(ActionKey key) {
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
