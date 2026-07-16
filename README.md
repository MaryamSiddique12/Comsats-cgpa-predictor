# COMSATS CGPA Predictor

A Flutter Web app that helps COMSATS students predict semester GPA, predict
CGPA, and calculate the minimum final-exam marks needed to hit a target
grade. Built with a clean, layered architecture so it can grow into
multi-university support, accounts, persistence, and more without a rewrite.

## Project structure

```
comsats_cgpa_predictor/
├── pubspec.yaml
└── lib/
    ├── main.dart                          # App entry point (MaterialApp, theme, home)
    │
    ├── core/                              # Cross-cutting, UI-agnostic building blocks
    │   ├── constants/
    │   │   ├── app_colors.dart            # Color palette (single source of truth)
    │   │   ├── app_text_styles.dart       # Typography scale
    │   │   └── app_strings.dart           # All user-facing copy
    │   ├── theme/
    │   │   └── app_theme.dart             # ThemeData: inputs, buttons, cards
    │   └── utils/
    │       └── validators.dart            # Pure form-validation functions
    │
    ├── models/                            # Plain data classes + the grading-system contract
    │   ├── grading_system.dart            # Abstract GradingSystem + GradeBand (extensibility seam)
    │   ├── comsats_grading_system.dart     # Concrete COMSATS implementation
    │   ├── course_input.dart              # Immutable snapshot of the form
    │   └── calculation_result.dart        # Immutable snapshot of a calculation's output
    │
    ├── services/
    │   └── gpa_calculator_service.dart    # All GPA/CGPA math, no Flutter/UI imports
    │
    ├── state/
    │   └── calculator_controller.dart     # ChangeNotifier: owns active grading system + result
    │
    ├── widgets/                           # Small, reusable, presentation-only pieces
    │   ├── gradient_header.dart           # Dark blue gradient hero header
    │   ├── custom_text_field.dart         # Labeled numeric field w/ validation
    │   ├── custom_dropdown.dart           # Labeled dropdown (grade / future university)
    │   ├── result_card.dart               # Single dashboard result card
    │   ├── input_section.dart             # Full input form (fields + Calculate/Reset)
    │   └── results_section.dart           # Result grid + empty state
    │
    └── screens/
        └── home_screen.dart               # Composes header + input card + results card
```

## Architecture at a glance

- **models/** hold data and the `GradingSystem` contract — no Flutter imports.
- **services/** hold business logic (`GpaCalculatorService`) — no Flutter imports either, so it's fully unit-testable.
- **state/** is the one `ChangeNotifier` (`CalculatorController`) that bridges the pure service layer to the widget tree.
- **widgets/** are small and dumb: they take data + callbacks, they don't know about the service.
- **screens/** compose widgets into full pages.
- **core/** is shared, non-domain-specific plumbing (colors, type, strings, validators, theme).

This layering is what makes each "Future Expansion" item a localized change:

| Future feature | Where it plugs in |
|---|---|
| Another university's grading scale | Add a new class implementing `GradingSystem` in `models/`, alongside `ComsatsGradingSystem` |
| Let the user pick their university | `CalculatorController` takes `gradingSystem` in its constructor already — just add a selector widget that swaps it in |
| Multiple courses / real semester GPA | Extend `CourseInput`/`CalculationResult` to lists, update `GpaCalculatorService` to do a credit-weighted average across courses — `state/` and `widgets/` barely change |
| User accounts / cloud sync | New `services/auth_service.dart` + `services/sync_service.dart`; `CalculatorController` gains save/load calls |
| Local persistence of scenarios | Add `shared_preferences` (already noted in `pubspec.yaml`) and a `services/storage_service.dart` |
| "What-if" scenario comparison screen | New file under `screens/`, reusing `GpaCalculatorService` and `ResultCard` |
| Study planner / notifications | New top-level `models/`, `services/`, and `screens/` files — existing calculator code is untouched |

## Design notes

- Dark blue gradient header, white rounded content cards with soft shadows, blue accent — all driven from `AppColors` / `AppTheme` so re-theming later (e.g. per-university branding) is a one-file change.
- Responsive: `MediaQuery` breakpoint at 700px switches the input grid and result grid between 1 and 2 columns.
- Grading scale used for the MVP (COMSATS absolute grading, 4.0 scale): A (85+) → A- (80) → B+ (75) → B (71) → B- (68) → C+ (64) → C (61) → C- (58) → D+ (54) → D (50) → F (<50). This lives entirely in `ComsatsGradingSystem` and can be adjusted or swapped without touching any other file.

## Calculation logic

1. **Required final marks** — works backward from the target grade's minimum percentage to find how many marks are needed in the final exam; flags the target as already-secured or mathematically unreachable when relevant.
2. **Predicted course GPA** — the grade point for the predicted final percentage (target percentage if achievable, otherwise the ceiling with full final marks).
3. **Predicted semester GPA** — in this single-course MVP, equal to the predicted course GPA (documented as the seam to extend into a credit-weighted multi-course average later).
4. **Predicted updated CGPA** — standard credit-weighted rollup: `(oldCGPA × completedHours + semesterGPA × newHours) / (completedHours + newHours)`.

## Running the project

```bash
flutter pub get
flutter run -d chrome
```

(Requires the Flutter SDK with web support enabled — this environment doesn't have Flutter installed, so the code has been written and manually reviewed for correctness rather than compiled here. Run `flutter analyze` locally after pulling it in to double check before you build on top of it.)
