

### Documentation for `CustomExpandableBottomSheetRoute` and `customExpandableBottomSheet`

This document provides an overview of the `CustomExpandableBottomSheetRoute` class and the `customExpandableBottomSheet` function, which are used to create and display a highly customizable expandable bottom sheet in a Flutter application.

---

## Table of Contents
1. [Introduction](#introduction)
2. [CustomExpandableBottomSheetRoute](#customexpandablebottomsheetroute)
   - [Constructor](#constructor)
   - [Properties](#properties)
   - [Methods](#methods)
3. [customExpandableBottomSheet](#customexpandablebottomsheet)
   - [Parameters](#parameters)
   - [Usage](#usage)
4. [Example](#example)

---

## Introduction

The `CustomExpandableBottomSheetRoute` is a `PopupRoute` that displays a bottom sheet which can expand and contract based on user interaction or programmatic control. It supports opening from both the top and the bottom of the screen, and offers extensive customization options for appearance and behavior.

The `customExpandableBottomSheet` function is a convenience method to display the bottom sheet using the `CustomExpandableBottomSheetRoute`.

---

## CustomExpandableBottomSheetRoute

### Constructor

```dart
CustomExpandableBottomSheetRoute({
  required this.builder,
  this.theme,
  this.barrierLabel,
  this.backgroundColor,
  this.isPersistent = false,
  this.elevation,
  this.shape,
  this.clipBehavior,
  this.modalBarrierColor,
  this.isDismissible = true,
  this.enableDrag = true,
  this.isScrollControlled = true,
  this.scaffoldKey,
  this.messengerKey,
  super.settings,
  this.enterBottomSheetDuration = const Duration(milliseconds: 250),
  this.exitBottomSheetDuration = const Duration(milliseconds: 200),
  this.curve,
  this.initialChildSize = 0.5,
  this.minChildSize = 0.03,
  this.maxChildSize = 1.0,
  this.borderRadius = 15.0,
  this.startFromTop = false,
  this.snap = false,
  this.isShowCloseBottom = true,
  this.closeIcon = Icons.close,
  this.indicatorColor = const Color.fromRGBO(224, 224, 224, 1),
});
```

### Properties

- **`builder`**: A builder function that returns the widget tree representing the content of the bottom sheet.
- **`scaffoldKey`**: A key to access the `ScaffoldState` of the internal `Scaffold` used to display the bottom sheet.
- **`messengerKey`**: A key to access the `ScaffoldMessengerState`.
- **`initialChildSize`**: The initial size of the bottom sheet, expressed as a fraction of the screen height.
- **`minChildSize`**: The minimum size of the bottom sheet, expressed as a fraction of the screen height.
- **`maxChildSize`**: The maximum size of the bottom sheet, expressed as a fraction of the screen height.
- **`borderRadius`**: The radius of the top corners of the bottom sheet.
- **`startFromTop`**: Whether the bottom sheet should open from the top of the screen instead of the bottom.
- **`snap`**: Whether the bottom sheet should snap to `initialChildSize`, `minChildSize`, or `maxChildSize`.
- **`theme`**: The theme to apply to the bottom sheet.
- **`backgroundColor`**: The background color of the bottom sheet.
- **`elevation`**: The elevation of the bottom sheet.
- **`shape`**: The shape of the bottom sheet.
- **`clipBehavior`**: The clipping behavior of the bottom sheet.
- **`modalBarrierColor`**: The color of the modal barrier that darkens the background behind the bottom sheet.
- **`isPersistent`**: Whether the bottom sheet should be persistent.
- **`isScrollControlled`**: Whether the bottom sheet's height is determined by its content.
- **`isDismissible`**: Whether the bottom sheet can be dismissed by tapping on the modal barrier.
- **`enableDrag`**: Whether the bottom sheet can be dragged by the user.
- **`enterBottomSheetDuration`**: The duration of the animation that slides the bottom sheet into view.
- **`exitBottomSheetDuration`**: The duration of the animation that slides the bottom sheet out of view.
- **`curve`**: The curve to use for the animation that slides the bottom sheet into and out of view.
- **`isShowCloseBottom`**: Whether to show the close button at the bottom.
- **`closeIcon`**: The icon to use for the close button.
- **`indicatorColor`**: The color of the indicator.

### Methods

- **`createAnimation()`**: Creates the animation for the bottom sheet's entrance and exit transitions.
- **`createAnimationController()`**: Creates the animation controller for managing the bottom sheet's animations.
- **`buildPage()`**: Builds the bottom sheet's UI.
- **`dispose()`**: Disposes of the animation controller and reports the route disposal.

---

## customExpandableBottomSheet

### Parameters

- **`builder`**: Required. A builder function that returns the widget tree for the bottom sheet content.
- **`initialChildSize`**: The initial size of the bottom sheet (fraction of screen height). Defaults to `0.0` for top-down.
- **`minChildSize`**: The minimum size of the bottom sheet (fraction of screen height). Defaults to `0.0` for top-down.
- **`maxChildSize`**: The maximum size of the bottom sheet (fraction of screen height). Defaults to `1.0`.
- **`borderRadius`**: The radius of the rounded corners. Defaults to `15.0`.
- **`isDismissible`**: Whether the bottom sheet can be dismissed by tapping the barrier. Defaults to `true`.
- **`enableDrag`**: Whether the bottom sheet can be dragged. Defaults to `true`.
- **`snap`**: Whether the bottom sheet should snap to specific sizes. Defaults to `false`.
- **`backgroundColor`**: The background color of the bottom sheet.
- **`elevation`**: The elevation of the bottom sheet.
- **`enterBottomSheetDuration`**: The duration of the entrance animation.
- **`exitBottomSheetDuration`**: The duration of the exit animation.
- **`theme`**: A theme to apply to the bottom sheet.
- **`curve`**: The animation curve.
- **`shape`**: The shape of the bottom sheet.
- **`barrierLabel`**: The label for the barrier.
- **`clipBehavior`**: The clip behavior.
- **`isPersistent`**: Whether the bottom sheet is persistent (cannot be dismissed by tapping outside). Defaults to `false`.
- **`isScrollControlled`**: Whether the bottom sheet is scroll-controlled. Defaults to `true`.
- **`messengerKey`**: A key for accessing the `ScaffoldMessengerState`.
- **`modalBarrierColor`**: The color of the modal barrier.
- **`scaffoldKey`**: A key for accessing the `ScaffoldState`.
- **`settings`**: Route settings.
- **`startFromTop`**: Whether the bottom sheet should open from the top. Defaults to `true`.
- **`isShowCloseBottom`**: Whether to show the close button. Defaults to `false`.
- **`closeIcon`**: The icon to use for the close button. Defaults to `Icons.close`.
- **`indicatorColor`**: The color of the indicator. Defaults to `Color.fromRGBO(224, 224, 224, 1)`.

### Usage

```dart
Get.customExpandableBottomSheet(
  builder: (context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This is a custom expandable bottom sheet'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  },
  initialChildSize: 0.5,
  minChildSize: 0.25,
  maxChildSize: 0.75,
  borderRadius: 20.0,
  isDismissible: true,
  enableDrag: true,
  startFromTop: false,
);
```

---

## Example

Here is a complete example demonstrating how to use the `customExpandableBottomSheet` function:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Expandable Bottom Sheet Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.customExpandableBottomSheet(
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('This is a custom expandable bottom sheet'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              initialChildSize: 0.5,
              minChildSize: 0.25,
              maxChildSize: 0.75,
              borderRadius: 20.0,
              isDismissible: true,
              enableDrag: true,
              startFromTop: false,
            );
          },
          child: Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
```

---

