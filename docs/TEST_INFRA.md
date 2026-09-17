# E2E Test Infra: WhatsApp Chat Wrapped Flutter

## Test Philosophy
- Opaque-box, requirement-driven. Derived strictly from `ORIGINAL_REQUEST.md` and `PROJECT.md § Feature Inventory`.
- Methodology: Category-Partition + Boundary Value Analysis (BVA) + Pairwise Combinatorial + Real-World Workload Testing.
- Framework: `flutter_test` / Dart unit & widget tests.

## Test Architecture
- Test files located in `test/e2e/`:
  * `test/e2e/tier1_feature_test.dart` — Feature isolation tests (>=5 cases per feature).
  * `test/e2e/tier2_boundary_test.dart` — Boundary and edge conditions (empty files, huge chats, unicode edge cases, timestamp formats).
  * `test/e2e/tier3_combination_test.dart` — Cross-feature interactions (ZIP + multi-format + casal analytics + stories data generation).
  * `test/e2e/tier4_realworld_test.dart` — Full end-to-end user workflows using real sample export files (e.g. `Conversa do WhatsApp com João Arthur Britto.txt`).
- Test runner invocation:
  `flutter test test/e2e/`
- Pass/Fail Semantics:
  All tests must pass with exit code 0 and zero unhandled exceptions.

## Test Coverage Thresholds
- 36 inventoried features.
- Tier 1: >=5 per feature (>=180 test cases).
- Tier 2: >=5 boundary/corner cases per feature area (>=60 test cases).
- Tier 3: pairwise coverage of major feature interactions (>=36 test cases).
- Tier 4: realistic full-journey scenarios (>=18 application scenarios).
- Total target: >294 test cases.
