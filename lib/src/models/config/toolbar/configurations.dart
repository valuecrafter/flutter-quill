import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'buttons/base.dart';
import 'buttons/font_family.dart';
// import 'buttons/font_size.dart';
import 'buttons/history.dart';

export './buttons/base.dart';
export './buttons/font_family.dart';
export './buttons/font_size.dart';
export './buttons/history.dart';
export './buttons/toggle_style.dart';

/// The default size of the icon of a button.
const double kDefaultIconSize = 18;

/// The default size for the toolbar (width, height)
const double defaultToolbarSize = kDefaultIconSize * 2;

/// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

/// The horizontal margin between the contents of each toolbar section.
const double kToolbarSectionSpacing = 4;

/// The configurations for the toolbar widget of flutter quill
@immutable
class QuillToolbarConfigurations extends Equatable {
  const QuillToolbarConfigurations({
    this.buttonOptions = const QuillToolbarButtonOptions(),
    this.multiRowsDisplay = true,
    this.fontFamilyValues,

    /// By default it will calculated based on the [baseOptions] iconSize
    /// You can change it but the the change only apply if
    /// the [multiRowsDisplay] is false, if [multiRowsDisplay] then the value
    /// will be [kDefaultIconSize] * 2
    double? toolbarSize,
  }) : _toolbarSize = toolbarSize;

  final double? _toolbarSize;

  /// The toolbar size, by default it will be `baseButtonOptions.iconSize * 2`
  double get toolbarSize {
    final alternativeToolbarSize = _toolbarSize;
    if (alternativeToolbarSize != null) {
      return alternativeToolbarSize;
    }
    return buttonOptions.base.globalIconSize * 2;
  }

  /// If you want change spesefic buttons or all of them
  /// then you came to the right place
  final QuillToolbarButtonOptions buttonOptions;
  final bool multiRowsDisplay;

  /// By default will be final
  /// ```
  /// {
  ///   'Sans Serif': 'sans-serif',
  ///   'Serif': 'serif',
  ///   'Monospace': 'monospace',
  ///   'Ibarra Real Nova': 'ibarra-real-nova',
  ///   'SquarePeg': 'square-peg',
  ///   'Nunito': 'nunito',
  ///   'Pacifico': 'pacifico',
  ///   'Roboto Mono': 'roboto-mono',
  ///   'Clear'.i18n: 'Clear'
  /// };
  /// ```
  final Map<String, String>? fontFamilyValues;

  @override
  List<Object?> get props => [
        buttonOptions,
        multiRowsDisplay,
        fontFamilyValues,
        toolbarSize,
      ];
}

/// The configurations for the buttons of the toolbar widget of flutter quill
@immutable
class QuillToolbarButtonOptions extends Equatable {
  const QuillToolbarButtonOptions({
    this.base = const QuillToolbarBaseButtonOptions(),
    this.undoHistory = const QuillToolbarHistoryButtonOptions(
      isUndo: true,
    ),
    this.redoHistory = const QuillToolbarHistoryButtonOptions(
      isUndo: false,
    ),
    this.fontFamily = const QuillToolbarFontFamilyButtonOptions(),
    // this.fontSize = const QuillToolbarFontSizeButtonOptions(),
  });

  /// The base configurations for all the buttons which will apply to all
  /// but if the options overrided in the spesefic button options
  /// then it will use that instead
  final QuillToolbarBaseButtonOptions base;
  final QuillToolbarHistoryButtonOptions undoHistory;
  final QuillToolbarHistoryButtonOptions redoHistory;
  final QuillToolbarFontFamilyButtonOptions fontFamily;
  // final QuillToolbarFontSizeButtonOptions fontSize;

  @override
  List<Object?> get props => [
        base,
      ];
}
