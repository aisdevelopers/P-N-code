## Performance Optimization
* **Lists:** Use `ListView.builder` or `SliverList` for performance in large digit lists.
* **Isolates:** Use `compute()` for expensive animations or data parsing if UI lags.
* **Const:** Use `const` constructors everywhere possible to reduce rebuilds.
* **Build Methods:** Avoid expensive operations or logic inside `build()`.

## State Management (GetX)
* **Reactive:** Use `.obs` and `Obx()` for all UI updates.
* **Lean Controllers:** Business logic only in controllers.
* **Lean Views:** Views handle UI widgets and structure only.

## Animations & Trick Logic
* **Physics:** Maintain smooth transitions (Apple-minimalist but with high-fidelity effects).
* **Isolation:** Keep complex animations like `_SlotMachineRevealAnimation` in separate widgets.

## Visual Design & Theming
* **Typography:** Use modern typography (e.g., from Google Fonts like Inter or Outfit) instead of default browser fonts.
* **Colors:** Use harmonious color palettes (HSL tailored, sleek dark modes) with smooth gradients.
* **Interactive Elements:** Use hover effects and micro-animations to make the interface feel alive.
* **Consistency:** Centralized theme usage in `lib/app/utils/themes/app_theme.dart`.

## Documentation Philosophy
* **Comment Wisely:** Explain *why* certain trick logic is implemented, not just *what* it does.
* **Clean Code:** Self-explanatory naming is preferred over extensive comments.
* **Doc Comments:** Use `///` for documentation to be picked up by tools.

## Accessibility
* **Contrast:** Maintain high contrast for accessibility in accessibility modes (if added).
* **Semantics:** Use `Semantics` widget for critical interactive elements.

## Analysis Options
Strictly follow `flutter_lints` and `analysis_options.yaml`.

```yaml
include: package:flutter_lints/flutter.yaml
linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    always_use_package_imports: true
```
