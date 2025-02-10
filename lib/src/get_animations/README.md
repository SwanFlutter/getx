
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


