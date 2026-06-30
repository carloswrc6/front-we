import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';
import 'package:frontwe/presentation/shared/widgets/CustomDialog.dart';
import 'package:frontwe/presentation/shared/widgets/CountrySelector.dart';
import 'package:go_router/go_router.dart';

class CreateDishScreen extends ConsumerStatefulWidget {
  const CreateDishScreen({super.key});

  @override
  ConsumerState<CreateDishScreen> createState() => _CreateDishScreenState();
}

class _CreateDishScreenState extends ConsumerState<CreateDishScreen> {
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _imageController = TextEditingController();

  String? _selectedCountryId;
  String? _selectedMealType;
  bool _isLoading = false;

  String? _nameError;
  String? _countryError;
  String? _mealTypeError;

  final _mealTypes = ['breakfast', 'lunch', 'dinner'];

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations t) {
    setState(() {
      _nameError = null;
      _countryError = null;
      _mealTypeError = null;
    });

    bool valid = true;

    if (_nameController.text.trim().isEmpty) {
      _nameError = '${t.dishName} ${t.errorLabel}';
      valid = false;
    }

    // ingredients and image are optional

    if (_selectedCountryId == null) {
      _countryError = t.filterCountry;
      valid = false;
    }

    if (_selectedMealType == null) {
      _mealTypeError = t.dishMealType;
      valid = false;
    }

    setState(() {});
    return valid;
  }

  Future<void> _handleSubmit() async {
    final t = AppLocalizations.of(context)!;
    if (!_validate(t)) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(dishRepositoryProvider);
      await repo.createDish(
        name: _nameController.text.trim(),
        image: _imageController.text.trim(),
        ingredients: _ingredientsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        mealType: _selectedMealType!,
        countryId: _selectedCountryId!,
      );

      if (!mounted) return;

      await CustomDialog.show(
        context: context,
        title: t.createDishTitle,
        message: t.dishCreated,
        type: DialogType.success,
        acceptText: 'Ok',
      );

      if (!mounted) return;
      ref.invalidate(localDishesProvider);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (!mounted) return;
      await CustomDialog.show(
        context: context,
        title: t.errorLabel,
        message: '$e',
        type: DialogType.error,
        acceptText: 'Ok',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final countriesAsync = ref.watch(localCountriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.createDishTitle)),
      body: countriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (countries) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CountrySelector(
                showAll: false,
                countries: countries,
                selectedCountryId: _selectedCountryId,
                onChanged: (v) => setState(() {
                  _selectedCountryId = v;
                  _countryError = null;
                }),
              ),
              if (_countryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _countryError!,
                    style: TextStyle(color: cs.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              Text(t.dishMealType, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _mealTypes.map((mt) {
                  final selected = _selectedMealType == mt;
                  return ChoiceChip(
                    label: Text(_mealTypeLabel(t, mt)),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      _selectedMealType = selected ? null : mt;
                      _mealTypeError = null;
                    }),
                  );
                }).toList(),
              ),
              if (_mealTypeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _mealTypeError!,
                    style: TextStyle(color: cs.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t.dishName,
                  border: const OutlineInputBorder(),
                  errorText: _nameError,
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _nameError = null),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: t.dishIngredients,
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: t.dishImage,
                  hintText: 'https://...',
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: t.createDish,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mealTypeLabel(AppLocalizations t, String mealType) {
    switch (mealType) {
      case 'breakfast':
        return t.mealTypeBreakfast;
      case 'lunch':
        return t.mealTypeLunch;
      case 'dinner':
        return t.mealTypeDinner;
      default:
        return mealType;
    }
  }
}
