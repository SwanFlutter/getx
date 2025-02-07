# Get Instance Management

This section of the code is responsible for managing dependencies and instances of classes in your application. With this system, you can easily create, manage, and delete class instances.


---


## Key Features

# Smart Dependency Management Extension

## Overview

The `SmartDependencyManagement` extension provides advanced dependency injection and management strategies for Dart applications using GetX.

## Methods

### 1. `smartPut<S>`

#### Description
Intelligently manages dependency injection with conditional logic and instance validation.

#### Example
```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.smartPut(
      builder: () => TodosController(),
      condition: () => true, // Optional condition
      validityCheck: (controller) => controller.todos.isEmpty,
      permanent: true,
    );
  }
}
```

### 2. `smartPutIf<S>`

#### Description
Advanced dependency management with primary and secondary conditions, including fallback mechanisms.

#### Example
```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.smartPutIf(
      primaryCondition: () => authController.isLoggedIn,
      builder: () => UserProfileController(),
      fallbackBuilder: () => GuestProfileController(),
      secondaryValidation: (controller) => controller.isProfileComplete(),
      enableLogging: true,
      permanent: true,
    );
  }
}
```

### 3. `lazyManage<S>`

#### Description
Simplified lazy initialization of dependencies with optional creation conditions.

#### Example
```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyManage(
      builder: () => ExpensiveServiceController(),
      initCondition: () => FeatureFlags.isAdvancedFeatureEnabled,
      permanent: false,
    );
  }
}
```

## Best Practices

- Use `smartPut` for simple conditional initialization
- Prefer `smartPutIf` for complex dependency scenarios
- Utilize `lazyManage` for performance-sensitive or optional services
- Always provide meaningful conditions and validation checks
- Enable logging during development for better debugging

## Use Cases

- Conditional service initialization
- Authentication-based dependency management
- Feature flag-controlled service creation
- Fallback strategies for dependencies
- Lazy loading of resource-intensive services

## Performance Considerations

- Minimal overhead for dependency management
- Efficient instance caching and reuse
- Supports multiple instances with tagging

---


# Authentication Dependency Management Example

## Scenario: Multi-Role Authentication System

### User Roles and Controllers
```dart
// Base authentication controller
class AuthController extends GetxController {
  final _userRole = UserRole.guest.obs;
  UserRole get userRole => _userRole.value;

  void login(String username, String password) {
    if (username == 'admin' && password == 'admin123') {
      _userRole.value = UserRole.admin;
    } else if (username == 'user' && password == 'user123') {
      _userRole.value = UserRole.premium;
    }
  }
}

// Enum for user roles
enum UserRole { guest, user, premium, admin }

// Different controllers for each role
class GuestController extends GetxController {
  List<String> get availableFeatures => ['limited_view'];
}

class UserController extends GetxController {
  List<String> get availableFeatures => ['basic_crud', 'profile_edit'];
}

class PremiumUserController extends GetxController {
  List<String> get availableFeatures => ['advanced_analytics', 'priority_support'];
}

class AdminController extends GetxController {
  List<String> get availableFeatures => [
    'user_management', 
    'system_config', 
    'full_dashboard_access'
  ];
}
```

### Smart Dependency Binding
```dart
class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // Global authentication controller
    Get.put(AuthController(), permanent: true);

    // Smart role-based controller injection
    Get.smartPutIf(
      primaryCondition: () {
        final auth = Get.find<AuthController>();
        return auth.userRole != UserRole.guest;
      },
      builder: () {
        final auth = Get.find<AuthController>();
        switch (auth.userRole) {
          case UserRole.admin:
            return AdminController();
          case UserRole.premium:
            return PremiumUserController();
          case UserRole.user:
            return UserController();
          default:
            return GuestController();
        }
      },
      fallbackBuilder: () => GuestController(),
      permanent: false,
      enableLogging: true
    );
  }
}
```

### Usage Example
```dart
class LoginPage extends GetView<AuthController> {
  void performLogin(String username, String password) {
    controller.login(username, password);
    
    // Automatically loads appropriate role controller
    final roleController = Get.find<dynamic>();
    
    print('Available Features: ${roleController.availableFeatures}');
  }
}
```

## Key Benefits
- Dynamic role-based dependency injection
- Secure and flexible authentication management
- Automatic controller switching based on user role
- Fallback to guest controller for unauthorized access