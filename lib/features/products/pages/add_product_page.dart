import 'package:app_platform_ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_state/state.dart';
import 'package:test_pkg/features/products/data/models/models.dart';

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
      productFormProvider.select(
            (form) => form.field<String>(ProductField.title),
      ),
    );

    final decField = ref.watch(
      productFormProvider.select(
            (form) => form.field<String>(ProductField.description),
      ),
    );
    final priceField = ref.watch(
      productFormProvider.select(
            (form) => form.field<String>(ProductField.price),
      ),
    );

    final codeField = ref.watch(
      productFormProvider.select(
            (form) => form.field<String>(ProductField.code),
      ),
    );

    final websiteField = ref.watch(
      productFormProvider.select(
            (form) => form.field<String>(ProductField.website),
      ),
    );

    final bool canSubmit = ref.watch(
        productFormProvider.select((form) => form.canSubmit));

    _listenForActions(key);

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  formNotifier.update(
                    ProductField.title,
                    value,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorText:
                  titleField.touched ? titleField.error : null,
                ),
              ),
              const SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              formNotifier.update(
                ProductField.description,
                value,
              );
            },
            decoration: InputDecoration(
              labelText: 'Description',
              errorText:
              titleField.touched ? decField.error : null,
            ),
          ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) {
                  formNotifier.update(
                    ProductField.price,
                    value,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  errorText:
                  titleField.touched ? priceField.error : null,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) {
                  formNotifier.updateAsync(
                    ProductField.code,
                    value,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Code',
                  errorText:
                  codeField.touched ? codeField.error : null,
                  suffixIcon: codeField.isValidating
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Website',
                keyboardType: TextInputType.emailAddress,
                errorText:
                websiteField.touched ? websiteField.error : null,
                isLoading: websiteField.isValidating,
                onChanged: (value) {
                  formNotifier.update(ProductField.website, value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: canSubmit && isSaving
                    ? null
                    : () {
                        final form = ref.read(productFormProvider);
                        formNotifier.validateAll();
                        if (!form.isValid) return;

                        notifier.create(
                          Product(
                            id: 1,
                            title: form
                                .field<String>(ProductField.title)
                                .value,
                            description: form
                                .field<String>(ProductField.description)
                                .value,
                            price: double.parse(
                              form
                                  .field<String>(ProductField.price)
                                  .value,
                            ),
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
