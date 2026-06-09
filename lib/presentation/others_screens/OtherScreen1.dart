import 'dart:async';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/widgets/custom_header.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class OtherScreen1 extends StatefulWidget {
  const OtherScreen1({super.key});

  @override
  State<OtherScreen1> createState() => _OtherScreen1State();
}

class _OtherScreen1State extends State<OtherScreen1> {
  // Control de la ruleta
  final StreamController<int> _selectedController =
      StreamController<int>.broadcast();

  Stream<int> get selectedStream => _selectedController.stream;

  int? selectedIndex;

  // Tipo seleccionado
  String selectedType = "Desayuno";

  // Datos por categoría
  final Map<String, List<String>> foodOptions = {
    "Desayuno": ["Pan", "Huevos", "Avena", "Cereal", "Fruta"],
    "Almuerzo": [
      "Arroz con pollo",
      "Lomo saltado",
      "Pasta",
      "Ensalada",
      "Sopa",
    ],
    "Cena": ["Pizza", "Sandwich", "Sopa ligera", "Pollo", "Ensalada"],
    "Snack": ["1 Galletas", " 2Fruta", " 3Yogurt", "4Chips", "5Chocolate"],
  };

  List<String> get currentOptions => foodOptions[selectedType]!;

  List<String> get allOptions => foodOptions[selectedType]!;

  // List<String> get visibleOptions =>
  // allOptions.length > 3 ? allOptions.take(3).toList() : allOptions;
  List<String> visibleOptions = [];

  bool isSpinning = false;
  String? pendingResult;

  void updateVisibleOptions() {
    final all = foodOptions[selectedType]!;

    visibleOptions = all.length > 3 ? all.take(3).toList() : [...all];
  }

  void spinWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
      updateVisibleOptions(); // reset
    });

    final random = Random();
    final allOptions = foodOptions[selectedType]!;

    final fullIndex = random.nextInt(allOptions.length);
    final result = allOptions[fullIndex];

    pendingResult = result; // 🔥 guardar resultado

    int visibleIndex;

    if (visibleOptions.contains(result)) {
      visibleIndex = visibleOptions.indexOf(result);
    } else {
      setState(() {
        visibleOptions.add(result);
      });
      visibleIndex = visibleOptions.length - 1;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _selectedController.add(visibleIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    updateVisibleOptions(); // 🔥 inicializa la ruleta
  }

  @override
  void dispose() {
    _selectedController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(),
      drawer: SideMenu(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomHeader(
                icon: const Icon(Icons.fastfood, size: 32),
                // title: t?.title ?? "¿Qué comer?",
                // title: dotenv.env['THE_FOOD_KEY'] ?? 'no hay pk',
                title: Environment.THE_FOOD_KEY,
                subtitle: t?.subtitle ?? "Elige una opción al azar",
              ),

              const SizedBox(height: 20),

              // 🔘 Selector de tipo
              Wrap(
                spacing: 10,
                children: ["Desayuno", "Almuerzo", "Cena", "Snack"]
                    .map(
                      (type) => ChoiceChip(
                        label: Text(type),
                        selected: selectedType == type,
                        onSelected: (_) {
                          setState(() {
                            selectedType = type;
                            updateVisibleOptions();
                          });
                        },
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 30),

              // 🎡 Ruleta
              SizedBox(
                height: 300,
                child: FortuneWheel(
                  selected: selectedStream,
                  animateFirst: false,
                  onAnimationEnd: () {
                    if (pendingResult != null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Resultado 🍽️"),
                          content: Text(pendingResult!),
                        ),
                      ).then((_) {
                        setState(() {
                          isSpinning = false;
                          pendingResult = null;
                        });
                      });
                    }
                  },
                  items: visibleOptions
                      .map((food) => FortuneItem(child: Text(food)))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),

              // 🎮 Botón girar
              ElevatedButton.icon(
                onPressed: spinWheel,
                icon: const Icon(Icons.casino),
                label: const Text("Girar"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
