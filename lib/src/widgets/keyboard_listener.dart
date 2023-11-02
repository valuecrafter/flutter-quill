import 'package:flutter/foundation.dart'
    show kIsWeb, TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuillPressedKeys extends ChangeNotifier {
  static QuillPressedKeys of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_QuillPressedKeysAccess>();
    return widget!.pressedKeys;
  }

  bool _metaPressed = false;
  bool _controlPressed = false;

  /// Whether meta key is currently pressed.
  bool get metaPressed => _metaPressed;

  /// Whether control key is currently pressed.
  bool get controlPressed => _controlPressed;

  void _updatePressedKeys(Set<LogicalKeyboardKey> pressedKeys) {
    final meta = pressedKeys.contains(LogicalKeyboardKey.metaLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.metaRight);
    final control = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
        pressedKeys.contains(LogicalKeyboardKey.controlRight);
    if (_metaPressed != meta || _controlPressed != control) {
      _metaPressed = meta;
      _controlPressed = control;
      notifyListeners();
    }
  }

  void _updatePhysicalPressedKeys(Set<PhysicalKeyboardKey> pressedKeys) {
    final meta = pressedKeys.contains(PhysicalKeyboardKey.metaLeft) ||
        pressedKeys.contains(PhysicalKeyboardKey.metaRight);
    final control = pressedKeys.contains(PhysicalKeyboardKey.controlLeft) ||
        pressedKeys.contains(PhysicalKeyboardKey.controlRight);
    if (_metaPressed != meta || _controlPressed != control) {
      _metaPressed = meta;
      _controlPressed = control;
      notifyListeners();
    }
  }
}

class QuillKeyboardListener extends StatefulWidget {
  const QuillKeyboardListener({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  QuillKeyboardListenerState createState() => QuillKeyboardListenerState();
}

class QuillKeyboardListenerState extends State<QuillKeyboardListener> {
  final QuillPressedKeys _pressedKeys = QuillPressedKeys();
  bool _isWeb() {
    return kIsWeb;
  }

  bool _isMacOS([TargetPlatform? targetPlatform]) {
    if (_isWeb()) return false;
    targetPlatform ??= defaultTargetPlatform;
    return TargetPlatform.macOS == targetPlatform;
  }

  bool _keyEvent(KeyEvent event) {
    if (_isMacOS()) {
      _pressedKeys._updatePhysicalPressedKeys(
          HardwareKeyboard.instance.physicalKeysPressed);
    } else {
      _pressedKeys
          ._updatePressedKeys(HardwareKeyboard.instance.logicalKeysPressed);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_keyEvent);

    if (_isMacOS()) {
      _pressedKeys._updatePhysicalPressedKeys(
          HardwareKeyboard.instance.physicalKeysPressed);
    } else {
      _pressedKeys
          ._updatePressedKeys(HardwareKeyboard.instance.logicalKeysPressed);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_keyEvent);
    _pressedKeys.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _QuillPressedKeysAccess(
      pressedKeys: _pressedKeys,
      child: widget.child,
    );
  }
}

class _QuillPressedKeysAccess extends InheritedWidget {
  const _QuillPressedKeysAccess({
    required this.pressedKeys,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final QuillPressedKeys pressedKeys;

  @override
  bool updateShouldNotify(covariant _QuillPressedKeysAccess oldWidget) {
    return oldWidget.pressedKeys != pressedKeys;
  }
}
