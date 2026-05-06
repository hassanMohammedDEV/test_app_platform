import 'package:app_platform_ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_platform_state/state.dart';
import 'package:test_pkg/features/products/data/models/models.dart';
import 'package:test_pkg/features/products/providers/product_fields_notifier.dart';
import 'package:test_pkg/features/products/providers/product_validation_provider.dart';

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
    final formNotifier = ref.read(productValidationProvider.notifier);

    // final titleField = ref.watch(
    //   productFormProvider.select(
    //         (form) => form.field<String>(ProductField.title),
    //   ),
    // );
    //
    // final decField = ref.watch(
    //   productFormProvider.select(
    //         (form) => form.field<String>(ProductField.description),
    //   ),
    // );
    // final priceField = ref.watch(
    //   productFormProvider.select(
    //         (form) => form.field<String>(ProductField.price),
    //   ),
    // );
    //
    // final codeField = ref.watch(
    //   productFormProvider.select(
    //         (form) => form.field<String>(ProductField.code),
    //   ),
    // );
    //
    // final websiteField = ref.watch(
    //   productFormProvider.select(
    //         (form) => form.field<String>(ProductField.website),
    //   ),
    // );
    //
    final bool canSubmit = ref.watch(
        productValidationProvider.select((form) => form.canSubmit));

    _listenForActions(key);

    final fieldsState = ref.watch(productFieldsProvider);

    final validation =
    ref.watch(productValidationProvider);

    final fieldsNotifier =
    ref.read(productFieldsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  fieldsNotifier.setTitle(value);
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorText: validation
                      .field(ProductField.title)
                      .error,
                ),
              ),
              const SizedBox(height: 12),
          // TextField(
          //   onChanged: (value) {
          //     formNotifier.update(
          //       ProductField.description,
          //       value,
          //     );
          //   },
          //   decoration: InputDecoration(
          //     labelText: 'Description',
          //     errorText:
          //     titleField.touched ? decField.error : null,
          //   ),
          // ),
          //     const SizedBox(height: 12),
          //     TextField(
          //       onChanged: (value) {
          //         formNotifier.update(
          //           ProductField.price,
          //           value,
          //         );
          //       },
          //       decoration: InputDecoration(
          //         labelText: 'Price',
          //         errorText:
          //         titleField.touched ? priceField.error : null,
          //       ),
          //     ),
          //     const SizedBox(height: 12),
          //     TextField(
          //       onChanged: (value) {
          //         formNotifier.updateAsync(
          //           ProductField.code,
          //           value,
          //         );
          //       },
          //       decoration: InputDecoration(
          //         labelText: 'Code',
          //         errorText:
          //         codeField.touched ? codeField.error : null,
          //         suffixIcon: codeField.isValidating
          //             ? const SizedBox(
          //           width: 3,
          //           height: 3,
          //           child: Center(
          //             child: CircularProgressIndicator(
          //               strokeWidth: 2,
          //             ),
          //           ),
          //         )
          //             : null,
          //       ),
          //     ),
          //     const SizedBox(height: 12),
          //     AppTextField(
          //       label: 'Website',
          //       keyboardType: TextInputType.emailAddress,
          //       errorText:
          //       websiteField.touched ? websiteField.error : null,
          //       isLoading: websiteField.isValidating,
          //       onChanged: (value) {
          //         formNotifier.update(ProductField.website, value);
          //       },
          //     ),
              const SizedBox(height: 24),
          ElevatedButton(
            onPressed:
            (!canSubmit || isSaving)
                ? null
                : () {
              final fields =
              ref.read(productFieldsProvider);

              final validationNotifier =
              ref.read(productValidationProvider.notifier);

              final isValid =
              validationNotifier.validateForm(fields);

              if (!isValid) return;
              // notifier.create(
              //   Product(
              //     id: 1,
              //     title: form
              //         .field<String>(ProductField.title)
              //         .value,
              //     description: form
              //         .field<String>(ProductField.description)
              //         .value,
              //     price: double.parse(
              //       form
              //           .field<String>(ProductField.price)
              //           .value,
              //     ),
              //   ),
              // );
            },
            child: isSaving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            )
                : const Text('حفظ'),
          ),
            ],
          ),
        ),
      ),
    );
  }

  // void onEdit(){
  //   final crudState = ref.read(costCenterCrudProvider);
  //   if (crudState.isSuccess("fetch_details")) {
  //     CNavigator.push(context, const NewCostCenterScreen());
  //   } else if (crudState.isFailure("fetch_details")) {
  //     final error = crudState.get("fetch_details").error;
  //     CDialogs.alertSnackBar(message: error!.message);
  //   }
  // }

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
