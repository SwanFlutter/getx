
# GetX Animations

A powerful and easy-to-use animation library for Flutter, built on top of GetX.



## Features

- 🚀 Easy to use animation extensions
- 🎯 Pre-built common animations
- ⚡ Chainable animations
- 🔄 Sequential animations support
- 💪 Built on top of Flutter's animation system
- 📱 Optimized for performance



## Basic Usage

```dart


// Simple fade in animation
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).fadeIn();

// Chained animations
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)
.fadeIn(duration: Duration(seconds: 1))
.scale(begin: 0.5, end: 1.0);

// Sequential animations
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)
.fadeIn(duration: Duration(seconds: 1))
.scale(
  begin: 0.5, 
  end: 1.0,
  isSequential: true, // This animation will start after fadeIn completes
);
```

## Available Animations

### Fade Animations
- `fadeIn()`
- `fadeOut()`

### Transform Animations
- `scale(begin: double, end: double)`
- `rotate(begin: double, end: double)`
- `slide(offset: OffsetBuilder)`
- `spin()`
- `size(begin: double, end: double)`

### Special Effects
- `blur(begin: double, end: double)`
- `bounce(begin: double, end: double)`
- `flip(begin: double, end: double)`
- `wave(begin: double, end: double)`
- `wobble(begin: double, end: double)`

### Slide Animations
- `slideInLeft()`
- `slideInRight()`
- `slideInUp()`
- `slideInDown()`

## Advanced Usage

### Custom Duration and Delay

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).fadeIn(
  duration: Duration(milliseconds: 500),
  delay: Duration(milliseconds: 200),
);
```

### Animation Callbacks

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).fadeIn(
  onComplete: (controller) {
    print('Animation completed!');
  },
);
```

### Sequential Animations

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)
.fadeIn(duration: Duration(seconds: 1))
.scale(
  begin: 0.5,
  end: 1.0,
  isSequential: true,
  duration: Duration(seconds: 1),
)
.rotate(
  begin: 0,
  end: 360,
  isSequential: true,
  duration: Duration(seconds: 1),
);
```

## Custom Animation Example

```dart
// Create a bouncing card
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Bouncing Card'),
  ),
)
.scale(begin: 0.0, end: 1.0)
.bounce(
  begin: 0,
  end: 0.2,
  isSequential: true,
  duration: Duration(milliseconds: 500),
);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```


--- 

# Flutter Animations Documentation



## Core Concept: `GetAnimatedBuilder`

All animations in this library extend `GetAnimatedBuilder<T>`, which itself is a generic class that uses flutter `AnimatedBuilder`.  It handles the animation lifecycle, value updates, and rebuilding of the widget tree.  You don't interact with `GetAnimatedBuilder` directly, but understanding its role is important:

*   **`tween`**: Defines the range of values the animation will produce (e.g., from 0.0 to 1.0 for opacity).
*   **`builder`**: A function that's called every time the animation value changes.  It receives the current animation value and the child widget, and it returns the *transformed* widget (e.g., a widget with adjusted opacity, scale, or position).
*   **`duration`**:  How long the animation takes to complete.
*   **`delay`**:  How long to wait before starting the animation.
*   **`onComplete`**:  A callback function that's executed when the animation finishes.
*  **`idleValue`**: The value of tween when the animation is not active.
*   **`curve`**: An optional parameter to specify the animation curve, influencing the rate of change over time (e.g., `Curves.easeOut`, `Curves.bounceIn`).

## Available Animations

The following animation widgets are provided, each with specific parameters and usage examples:

### 1. `OpacityAnimation`

Changes the opacity of a widget.

*   **`begin`**:  Starting opacity (0.0 = transparent, 1.0 = opaque).
*   **`end`**: Ending opacity.
* **`idleValue`**: Default value of opacity for the animation.

```dart
OpacityAnimation(
  duration: const Duration(seconds: 1),
  delay: const Duration(milliseconds: 500),
  begin: 0.0,
  end: 1.0,
  idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
  onComplete: () {
    print('Opacity animation complete!');
  },
)
```

### 2. `FadeInAnimation`

A convenience class that extends `OpacityAnimation` to fade a widget in (from transparent to opaque).

```dart
FadeInAnimation(
  duration: const Duration(seconds: 1),
  delay: const Duration(milliseconds: 500),
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
)
```

### 3. `FadeOutAnimation`

A convenience class that extends `OpacityAnimation` to fade a widget out (from opaque to transparent).

```dart
FadeOutAnimation(
  duration: const Duration(seconds: 1),
  delay: const Duration(milliseconds: 500),
    idleValue: 1,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.green,
  ),
)
```

### 4. `RotateAnimation`

Rotates a widget.

*   **`begin`**:  Starting angle (in radians).
*   **`end`**:  Ending angle (in radians).
*   **`idleValue`**:  idleValue (in radians).

```dart
RotateAnimation(
  duration: const Duration(seconds: 2),
  begin: 0.0,
  end: 2 * pi, // Full rotation
  idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.yellow,
  ),
)
```

### 5. `ScaleAnimation`

Scales a widget.

*   **`begin`**:  Starting scale factor.
*   **`end`**:  Ending scale factor.
*   **`idleValue`**:  idleValue.

```dart
ScaleAnimation(
  duration: const Duration(seconds: 1),
  begin: 0.5,
  end: 2.0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.purple,
  ),
)
```

### 6. `BounceAnimation`
Scales a widget with bounce effect.

*   **`begin`**:  Starting scale factor.
*   **`end`**:  Ending scale factor.
*   **`curve`**: Curve for animation default value is `Curves.bounceOut`.
*   **`idleValue`**:  idleValue.

```dart
BounceAnimation(
  duration: const Duration(seconds: 1),
  begin: -1.0,
  end: 1.0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.purple,
  ),
)
```

### 7. `SpinAnimation`

Continuously rotates a widget 360 degrees.

*   **`idleValue`**:  idleValue.
```dart
SpinAnimation(
  duration: const Duration(seconds: 3),
    idleValue: 0,
  child: Icon(Icons.refresh),
)
```
### 8. `SizeAnimation`
Animation for size changes with scale effect.

*   **`begin`**: Starting size value.
*   **`end`**: Ending size value.
*   **`idleValue`**:  idleValue.

```dart
SizeAnimation(
  duration: const Duration(seconds: 1),
  begin: 0.5,
  end: 1.5,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.amber,
  ),
)
```

### 9. `BlurAnimation`
Applies a blur effect to a widget.

*  **`begin`**: Starting blur sigma value.
*  **`end`**: Ending blur sigma value.
*   **`idleValue`**:  idleValue.

```dart
BlurAnimation(
  duration: const Duration(seconds: 1),
  begin: 0.0,
  end: 10.0,
  idleValue: 0,
  child: Image.network('https://example.com/image.jpg'),
)
```
### 10. `FlipAnimation`
Flips a widget horizontally.

*   **`begin`**: Starting angle in radians.
*   **`end`**: Ending angle in radians.
*   **`idleValue`**:  idleValue.

```dart
FlipAnimation(
  duration: const Duration(seconds: 1),
  begin: 0.0,
  end: 1.0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.cyan,
    child: Center(child: Text('Flip Me')),
  ),
)
```

### 11. `WaveAnimation`
Creates a vertical wave-like motion.

*   **`begin`**: Starting vertical translation.
*   **`end`**: Ending vertical translation.
*   **`idleValue`**:  idleValue.

```dart
WaveAnimation(
  duration: const Duration(seconds: 2),
  begin: 0.0,
  end: 1.0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.teal,
  ),
)
```

### 12. `WobbleAnimation`
Adds a subtle wobble effect.

*    **`begin`**: Starting rotation angle.
*    **`end`**: Ending rotation angle.
*   **`idleValue`**:  idleValue.
```dart
WobbleAnimation(
  duration: const Duration(seconds: 2),
  begin: 0.0,
  end: 1.0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.indigo,
  ),
)
```
### 13. `SlideAnimation`

Slides a widget by a specified offset.  This is the base class for `SlideIn...` animations.

*   **`begin`**: Starting offset value multiplier.
*   **`end`**: Ending offset value multiplier.
*   **`offsetBuild`**: A function that takes the `BuildContext` and the current animation value (`double`) and returns an `Offset`. This determines the slide direction and magnitude.
*   **`idleValue`**:  idleValue.
```dart
// Example creating a custom slide from top-left corner.
SlideAnimation(
  duration: const Duration(seconds: 1),
  begin: -1,
  end: 0,
  idleValue: 0,
  offsetBuild: (context, value) => Offset(
    value * MediaQuery.of(context).size.width,
    value * MediaQuery.of(context).size.height,
  ),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.orange,
  ),
)
```
### 14. `SlideInLeftAnimation`

Slides a widget in from the left.

*    **`begin`**: Starting X offset.
*    **`end`**: Ending X offset.
*   **`idleValue`**:  idleValue.
```dart
SlideInLeftAnimation(
  duration: const Duration(seconds: 1),
  begin: -1,
  end: 0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.lime,
  ),
)
```

### 15. `SlideInRightAnimation`

Slides a widget in from the right.

*   **`begin`**: Starting X offset (negative values move it to the right).
*   **`end`**: Ending X offset.
*   **`idleValue`**:  idleValue.
```dart
SlideInRightAnimation(
  duration: const Duration(seconds: 1),
  begin: 1,
  end: 0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.brown,
  ),
)
```

### 16. `SlideInUpAnimation`

Slides a widget in from the bottom.

*    **`begin`**: Starting Y offset.
*    **`end`**: Ending Y offset.
*   **`idleValue`**:  idleValue.

```dart
SlideInUpAnimation(
  duration: const Duration(seconds: 1),
  begin: 1,
  end: 0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.grey,
  ),
)
```

### 17. `SlideInDownAnimation`

Slides a widget in from the top.
*    **`begin`**: Starting Y offset.
*    **`end`**: Ending Y offset.
*   **`idleValue`**:  idleValue.

```dart
SlideInDownAnimation(
  duration: const Duration(seconds: 1),
  begin: -1,
  end: 0,
    idleValue: 0,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blueGrey,
  ),
)
```
### 18. `ZoomAnimation`

Zooms a widget in or out, keeping its aspect ratio.

* **`begin`**: Start zoom value.
* **`end`**: End zoom value.
* **`idleValue`**: Idle value.

```dart
  ZoomAnimation(
      duration: const Duration(seconds: 2),
      begin: 0,
      end: 2,
      idleValue: 0,
      child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png"),
    )
```
### 19. `ColorAnimation`
Changes the color of the child widget.

*   **`begin`**: The starting color.
*   **`end`**: The ending color.
*   **`idleColor`** : The color for the widget when animation not active.
```dart
ColorAnimation(
  duration: const Duration(seconds: 3),
  begin: Colors.red,
  end: Colors.blue,
  idleColor: Colors.pink,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.white, // Initial color doesn't matter, it's overridden
  ),
)
```

## Common Parameters

All animation widgets share these common parameters:

*   **`key`**:  A standard Flutter `Key` for widget identification.
*   **`duration`**:  A `Duration` object specifying the animation's duration (e.g., `Duration(seconds: 1)`).
*   **`delay`**: A `Duration` object specifying a delay before the animation starts.
*   **`child`**: The widget to be animated.  This is *required*.
*   **`onComplete`**:  An optional callback function (`VoidCallback`) that's executed when the animation completes.

## Important Notes and Best Practices

*   **Performance:**  Animations can be performance-intensive.  Use them judiciously, especially on lower-end devices.  Avoid complex animations within lists or grids that might cause jank during scrolling.
*   **Composability:** You can nest these animations to create more complex effects. For example, you could combine a `ScaleAnimation` and a `RotateAnimation` to make a widget both grow and spin.
*   **Custom Animations:** The provided animations cover many common cases. If you need a highly specific animation, you can extend `GetAnimatedBuilder` directly and create your own `builder` and `tween`.  The `SlideAnimation` class provides a good example of how to create a custom animation.
* **`idleValue`**: Make sure that you added value for animation when it's not active using `idleValue`.

This comprehensive documentation, with clear examples and explanations, makes your animation library easy to use and understand. It covers all the provided animation classes, explains the core concepts, and provides guidance for creating custom animations.

