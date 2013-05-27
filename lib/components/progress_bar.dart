// Copyright (c) 2013, the Pixelate Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:html';
import 'dart:math' as Math;
import 'package:web_ui/web_ui.dart';
import 'package:pixelate/attribute_helpers.dart';
import 'expander.dart';

/// A progress bar.
///
/// The amount filled can be controlled in markup by using the max and value
/// attributes. By default the max value is set to 1, while the value is
/// initially set to 0. The minimum value is always assumed to be 0. The bar
/// will be filled by (value / max) * width.
///
///     <!-- A bar filled halfway -->
///     <div is="x-progress-bar" value="0.5"></div>
///     <!-- Another bar filled halfway but with a different maximum -->
///     <div is="x-progress-bar" value="5" max="10"></div>
///
/// Additionally a progress bar may be animated. The animation will stop once
/// bar is completely filled. By default no animation will occur.
///
///     <!-- An animated progress bar -->
///     <div is="x-progress-bar" animated="true"></div>
///
/// The [ProgressBarComponent] defines styles for the bar color, and the
/// animation.
///
///     div[is=x-progress-bar] {
///       /* The background of the animation */
///       -webkit-var-progress-bar-animation-background: ___;
///       /* The duration of the animation (NOT WORKING) */
///       -webkit-var-progress-bar-animation-duration: ___;
///       /* The width of the background (NOT WORKING) */
///       -webkit-var-progress-bar-animation-background-width: ___;
///       /* The height of the background (NOT WORKING) */
///       -webkit-var-progress-bar-animation-background-height: ___;
///       /* The color of the filled portion of the progress bar */
///       -webkit-var-progress-bar-fill-color:  ___;
///     }
///
/// \TODO Currently the CSS variables do not work if multiple -webkit-var(_) are
/// used in the same CSS declaration.
class ProgressBarComponent extends WebComponent {
  //---------------------------------------------------------------------
  // Class variables
  //---------------------------------------------------------------------

  /// The class name of the filled bar.
  static const String _fillClass = 'x-progress-bar_fill';
  /// The class name for an animated progress bar.
  static const String _animateClass = 'x-progress-bar_striped';
  /// The class name for stopping the animated progress bar.
  static const String _pausedClass = 'x-progress-bar_paused';

  //---------------------------------------------------------------------
  // Member variables
  //---------------------------------------------------------------------

  /// The filled portion of the bar.
  Element _fill;
  /// Whether the progress bar is animated.
  bool _animated = false;
  /// The current value of the progress bar.
  double _value = 0.0;
  /// The maximum value of the progress bar.
  double _maxValue = 1.0;

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  /// Whether the progress bar is animated.
  String get animated => _animated.toString();
  set animated(String value) {
    _animated = convertBoolean(value);

    _changeAnimation();
  }

  /// The current value of the progress bar.
  String get value => _value.toString();
  set value(String current) {
    _value = double.parse(current);

    _computeFill();
  }

  /// The maximum value of the progress bar.
  String get max => _maxValue.toString();
  set max(String value) {
    _maxValue = double.parse(value);

    _computeFill();
  }

  //---------------------------------------------------------------------
  // Web-UI methods
  //---------------------------------------------------------------------

  /// Called when the component is inserted into the tree.
  ///
  /// Used to initialize the component.
  void inserted() {
    // Get the child elements
    _fill = host.query('.$_fillClass');

    _changeAnimation();
    _computeFill();
  }

  //---------------------------------------------------------------------
  // Private methods
  //---------------------------------------------------------------------

  /// Handles animating the progress bar.
  void _changeAnimation() {
    if (_fill == null) {
      return;
    }

    if (_animated) {
      _fill.classes.add(_animateClass);
    } else {
      _fill.classes.remove(_animateClass);
    }
  }

  /// Computes the percentage the bar should be filled.
  void _computeFill() {
    if (_fill == null) {
      return;
    }

    if (_value >= _maxValue) {
      _fill.style.width = '100%';
      _fill.classes.add(_pausedClass);
    } else {
      var percentage = (_value / _maxValue) * 100.0;

      _fill.style.width = '${percentage}%';
      _fill.classes.remove(_pausedClass);
    }
  }
}
