# Get Instance Management

This section of the code is responsible for managing dependencies and instances of classes in your application. With this system, you can easily create, manage, and delete class instances.

## Key Features

### 1. **SmartPut**
`SmartPut` is an advanced method for dependency injection that combines the features of `put()` and `lazyPut()`.

#### Practical Examples:
```dart
// Authentication service that needs to be ready early
Get.smartPut(
  () => AuthService(),
  priority: Priority.high,
  permanent: true,
  lazy: false,
);
```

### 2. **Lifecycle Management**
Using `GetLifeCycleMixin`, you can manage the lifecycle of controllers and services. This includes methods like `onInit()`, `onReady()`, and `onClose()`.

#### Example:
```dart
class SomeController with GetLifeCycleMixin {
  @override
  void onInit() {
    super.onInit();
    // Initialization code
  }
}
```

### 3. **Group Management**
With `GroupManagement`, you can delete or reload all instances with a specific tag prefix.

#### Example:
```dart
// Delete all instances with the prefix 'user'
Get.deleteGroup('user');
```

### 4. **Instance Status**
Using `InstanceStatus`, you can get the status of all registered instances and check if any instance is in an error state.

#### Example:
```dart
final status = Get.getAllInstancesStatus();
final hasErrors = Get.hasErrors();
```

## How to Use

To use this system, simply utilize the methods provided in the various classes. These methods allow you to easily manage dependencies and take advantage of lifecycle management and instance status features.

### Important Notes

- It is not necessary to set all properties. In most cases, default values are sufficient and only need to be configured in specific cases.
- This system provides great flexibility and control over how your services and controllers are initialized and managed throughout your application's lifecycle.

```dart
// Complete example of usage in a real project:

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Core services with high priority
    Get.smartPut(
      () => AuthenticationService(),
      priority: Priority.high,  // Initializes first
      permanent: true,         // Never removed from memory
      lazy: false,            // Created immediately
    );

    // 2. Main controller with preload
    Get.smartPut(
      () => MainController(),
      preload: () async {
        await loadInitialData();
      },
      tag: 'main',           // Access with specific tag
    );

    // 3. Regular service with lazy loading
    Get.smartPut(
      () => UserService(),
      lazy: true,            // Created only on first use
      fenix: true,          // Can be recreated after deletion
    );

    return GetMaterialApp(/*...*/);
  }
}
```

Property Explanations:

1. **priority** (Optional, default: normal)
```dart
// Three priority levels:
Priority.high    // For critical services that need early initialization
Priority.normal  // For most services and controllers
Priority.low     // For non-essential services
```

2. **lazy** (Optional, default: true)
```dart
lazy: true   // Instance is created only when first requested
lazy: false  // Instance is created immediately upon registration
```

3. **permanent** (Optional, default: false)
```dart
permanent: true   // Instance is never removed from memory
permanent: false  // Instance can be removed with Get.delete()
```

4. **fenix** (Optional)
```dart
fenix: true   // If instance is deleted, it can be recreated
fenix: false  // After deletion, cannot be recreated
```

5. **tag** (Optional)
```dart
// Access instance with specific tag
Get.smartPut(() => UserController(), tag: 'user');
final controller = Get.find<UserController>(tag: 'user');
```

6. **preload** (Optional)
```dart
Get.smartPut(
  () => DatabaseService(),
  preload: () async {
    await initializeDatabase();
    await loadConfigs();
  }
);
```

Practical Examples:

1. For Core Services:
```dart
// Authentication service that needs to be ready early
Get.smartPut(
  () => AuthService(),
  priority: Priority.high,
  permanent: true,
  lazy: false,
);
```

2. For Page Controllers:
```dart
// Page controller that needs lazy loading
Get.smartPut(
  () => HomeController(),
  lazy: true,
  tag: 'home',
);
```

3. For Services Requiring Setup:
```dart
// API service needing initial setup
Get.smartPut(
  () => ApiService(),
  preload: () async {
    await loadApiKeys();
    await setupInterceptors();
  },
  priority: Priority.high,
);
```

4. For Temporary Services:
```dart
// Temporary service that can be deleted later
Get.smartPut(
  () => CacheService(),
  permanent: false,
  fenix: true,
);
```

Important Note: It's not necessary to set all properties. In most cases, default values are sufficient and only need to be configured in specific cases.

This dependency injection system provides great flexibility and control over how your services and controllers are initialized and managed throughout your application's lifecycle.
