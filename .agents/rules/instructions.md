---
trigger: always_on
---

Always follow proper flutter standards, industry best practices, proper folder structure and font consistency.
Follow proper standards.
Development should follow official recommendations from Flutter and the language standards of Dart.
1. Core Principles
Follow clean, maintainable, and scalable architecture.
Keep UI components reusable and modular.
Maintain consistency across the application.
Write readable and well-structured code.
Avoid shortcuts that reduce long-term maintainability.

2. Project Folder Structure
Use a scalable structure.
Guidelines:
Do not place all screens in one folder.
Each feature must be isolated.
Shared components go into shared/widgets.

3. Coding Standards
Naming Conventions
Type	Convention	Example
Classes	PascalCase	LoginScreen
Variables	camelCase	userName
Files	snake_case	login_screen.dart
Constants	camelCase or kCamelCase	apiTimeout
General Rules
Keep widgets small.
Avoid large files.
One widget per file when possible.
Avoid deeply nested widgets.
Use const widgets whenever possible.

4. UI and Design Consistency
All UI must follow a centralized design system.
Define these in the theme folder:
/theme/
  app_theme.dart
  app_colors.dart
  app_typography.dart
  app_spacing.dart
Rules:
Do not hardcode colors.
Do not hardcode font sizes.
Use theme styles everywhere.
Maintain consistent padding and spacing.

5. Font and Typography Rules
Use a single primary font family.
Define font styles in typography file.
Avoid inline text styling.
ex-
AppTextStyles.heading
AppTextStyles.body
AppTextStyles.caption

6. Reusable Widgets
Before creating a new UI component:
Check if it can be reused.
Move reusable widgets into:
/widgets/
Examples:
AppButton
AppTextField
LoadingIndicator
EmptyStateWidget

7. State Management
Use one consistent state management approach across the entire app.
Rules:
UI must not contain business logic.
State must be handled inside controllers/view models.
Keep screens lightweight.

8. Responsiveness
The application must support different screen sizes.
Guidelines:
Avoid fixed dimensions.
Use flexible layouts.
Test on:
small devices
large devices
tablets
Preferred tools:
MediaQuery
LayoutBuilder
Flexible
Expanded

9. Navigation Standards
Use a centralized navigation approach.
Rules:
Do not push routes directly from multiple places.
Keep navigation logic organized.
Maintain route constants.
Example structure:
/navigation/
  app_router.dart
  routes.dart

10. Error Handling
All features must include proper error handling.
Guidelines:
Show user-friendly error messages.
Avoid app crashes.
Handle UI failure states:
 loading
 empty
 error

11. Performance Best Practices
Follow these rules to keep the app performant:
Use const widgets.
Avoid unnecessary rebuilds.
Split large widgets.
Avoid logic inside build().
Lazy load heavy components.
Optimize list views.
Example:
Use:ListView.builder
Instead of:ListView with many static children

12. Dependency Management
Before adding a package:
Verify maintenance status.
Check community usage.
Ensure it is actively supported.
Rules:
  Avoid unnecessary dependencies.
  Prefer lightweight libraries.

13. API Integration (Future Implementation)
Although APIs are not integrated yet, follow these rules when implemented:
Use a repository pattern.
Separate API logic from UI.
Do not call APIs directly from screens.
Keep networking inside a service layer.
Suggested structure:
  core/services/
  features/feature_name/data/

15. Logging
Important application events should be logged.
Examples:
errors
navigation events
critical actions
Logging must not affect performance.

16. Code Review Rules
Before merging code:
Code must follow project structure.
No hardcoded UI values.
No unused imports.
Code must be readable and clean.
Reusable components must be extracted.

17. Scalability Requirement
The application must be designed to scale as more features are added.
Rules:
Every new module must be added as a feature.
Avoid tightly coupled components.
Mindful on micro-frontend too for future

18. General Development Rules
Always ensure:
Consistent UI.
Clean architecture.
Modular widgets.
Maintainable code.
Production-ready standards.