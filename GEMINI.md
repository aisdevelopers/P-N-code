## Project Overview: P-N-Code
This is a Flutter application (**pn_code**) focused on a sophisticated dialer interface with high-fidelity "trick" animations. It uses **GetX** for state management and **Hive** for local persistence.

## Quota Conservation (Auto-Enforced)
- Default model: **Gemini 3 Flash** unless the task is explicitly labeled COMPLEX.
- Output ONLY the minimal diff or changed code sections. No verbose explanations.
- Think in ≤5-word drafts per step. No long reasoning chains.
- Do NOT scan directories or files not listed in the task or current context.
- Do NOT re-read files already confirmed as loaded in this session.
- If Planning Mode is needed, complete the plan then switch to Fast Mode for execution.
- If quota visually shows <20%, stop and notify the user before starting a new task.

## Session Management
- At start: read `HANDOFF.md` if it exists. Confirm understanding in 1 line before starting.
- At end: update `HANDOFF.md` with status, modified files, next 3 tasks, and key decisions.
- Never exceed 80K estimated tokens per session — split into a new session instead.
- If context reaches 150K tokens, notify the user before proceeding.

## Prompting Rules
- Output format: diffs, code changes, or YAML only. Minimal markdown prose.
- Never regenerate a full file when only a few lines/methods changed.
- Ask before adding any new package or dependency.
- Do not run `flutter test`, `pub get`, or build commands via the built-in terminal — the user will handle those.

## GetX Structure Guidelines
- **Feature-First Architecture**:
  - `lib/app/modules/[feature]/`:
    - `[feature]_controller.dart` (Extend `GetxController`)
    - `[feature]_view.dart` (Use `GetView<Controller>`)
    - `[feature]_binding.dart` (Register dependencies)
- **Shared Logic**:
  - `lib/app/utils/`: Themes, constants, services.
  - `lib/app/data/`: Models, providers (Hive adapters).
- **Routing**:
  - `lib/app/routes/`: Centralized routes in `app_pages.dart`.

## GetX-Specific Rules
- Use `Rx` types (`RxBool`, `RxInt`, `RxString`, `RxList`, etc.) for reactive state.
- Use `.obs` and `Obx()` (or `GetX<Controller>()`) for reactive UI updates.
- Keep controllers focused on business logic; views handle only the UI.
- Always use `Get.put()`, `Get.lazyPut()`, or bindings for DI.
- No Riverpod, Bloc, or Provider.

## Hive Usage Rules
- Register all adapters in `main.dart`.
- Use `LocalStorage.init()` and handled methods for simple data.
- Ensure all model classes have appropriate `@HiveType` and `@HiveField` annotations.
- Regenerate adapters using `build_runner` after model changes.

## Animation & Performance
- The project relies heavily on `animated_glitch`, `animated_text_kit`, and custom animations (e.g., `_SlotMachineRevealAnimation`).
- Use `const` constructors everywhere possible to reduce rebuilds.
- Keep widgets under 150 lines. Flag if exceeded.

## Protected Areas (Never Auto-Modify)
- `lib/app/utils/` → Ask first (themes, network, constants).
- `lib/app/routes/` → Ask first.
- Any migration or generated files (`.g.dart`) → Never auto-modify.
