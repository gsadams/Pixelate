// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:web_ui/web_ui.dart';

/// Gets any of the web component elements.
void getElements() {
  var barElement = query('#progress');
  var bar = barElement.xtag as ProgressBarComponent;
  double value = 0.0;
  var duration = const Duration(milliseconds: 500);

  var timer = new Timer.periodic(duration, (_) {
    value += 0.1;
    if (value >= 2.0) {
      value = 0.0;
    }

    bar.value = value.toString();
  });
}

/// Main entry-point to the application
void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;

  // Components cannot be queried until after main completes
  // Use the timer to create a callback that immediately fires so
  // the components can be retrieved
  Timer.run(getElements);
}