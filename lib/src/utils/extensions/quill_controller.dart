import 'package:flutter/widgets.dart' show BuildContext;

import '../../../flutter_quill.dart' show QuillController, QuillProvider;
import 'build_context.dart';

extension QuillControllerExt on QuillController? {
  /// Simple logic to use the current passed controller if not null
  /// if null then we will have to use the default one from [QuillProvider]
  /// using the [context]
  QuillController notNull(BuildContext context) {
    final controller = this;
    if (controller != null) {
      return controller;
    }
    return context.requireQuillController;
  }
}
