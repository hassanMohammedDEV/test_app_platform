import 'package:app_platform_core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productFiltersProvider = StateProvider<QueryFilters>(
  (_) => const QueryFilters({}),
);