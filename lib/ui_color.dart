library parse_color;

import 'package:flutter/material.dart';

class UIColorManager {

  final Map<dynamic, Color> _cache;

  static UIColorManager? instance;

  UIColorManager._( this._cache );

  factory UIColorManager( [ Map<dynamic, Color>? preCache ] ) {
    return instance ??= UIColorManager._( {
      ..._defaults(),
      ...preCache ?? {},
    });
  }

  static Map<dynamic, Color> _defaults() {
    return {
      'black': Colors.black,
      'white': Colors.white,
      'grey': Colors.grey,
      'transparent': Colors.transparent,
      'clear': Colors.transparent,
      'redAccent': Colors.redAccent,
      'amber': Colors.amber,
      'amberAccent': Colors.amberAccent,
      'blue': Colors.blue,
      'blueAccent': Colors.blueAccent,
      'blueGrey': Colors.blueGrey,
      'brown': Colors.brown,
      'cyan': Colors.cyan,
      'cyanAccent': Colors.cyanAccent,
      'orange': Colors.orange,
      'orangeAccent': Colors.orangeAccent,
      'deepOrange': Colors.deepOrange,
      'deepOrangeAccent': Colors.deepOrangeAccent,
      'green': Colors.green,
      'greenAccent': Colors.greenAccent,
      'lightGreen': Colors.lightGreen,
      'lightGreenAccent': Colors.lightGreenAccent,
      'purple': Colors.purple,
      'purpleAccent': Colors.purpleAccent,
      'deepPurple': Colors.deepPurple,
      'deepPurpleAccent': Colors.deepPurpleAccent,
    };
  }

  void set( dynamic key, Color color ) => _cache[ key ] = color;

  void unset( dynamic key ) => _cache.remove( key );

  void load( Map<dynamic, Color> colors, [ bool override = true ] ) {
    if ( override ) {
      _cache.addAll( colors );
    } else {
      for ( var key in colors.keys ) {
        if ( ! _cache.containsKey( key ) ) {
          _cache[ key ] = colors[ key ]!;
        }
      }
    }
  }

  Color _parse( dynamic input, { Color fallback = Colors.transparent }) {
    if ( input is Color ) {
      return input;
    }

    Colors.red;

    if ( input == null ) {
      return fallback;
    }

    // If input is int, use Color constructor.
    if ( input is int ) {
      return _cache[ input ] ??= Color( input );
    }

    if ( _cache.containsKey( input ) ) {
      return _cache[ input ]!;
    }

    if ( input is String ) {

      if ( input.toLowerCase().startsWith( 'rgb' ) ) {
        return _cache[ input ] ??= _colorFromRGBString( input, fallback );
      }

      return _cache[ input ] ??= _colorFromHex( input, fallback );

    }

    return fallback;
  }

  Color _colorFromHex( String input, Color fallback ) {
    String c = input.toUpperCase().replaceAll("#", "");

    if ( ! [ 6, 8 ].contains( c.length ) ) {
      return fallback;
    }

    if ( c.length == 6 ) {
      c = 'FF$c';
    }

    int? iVal = int.tryParse( c, radix: 16 );

    if ( iVal != null ) {
      return Color( iVal );
    }

    return fallback;
  }

  Color _colorFromRGBString( String color, Color fallback ) {
    try {

      bool hasAlpha = color.toLowerCase().startsWith( 'rgba' );

      String numParts = color
          .replaceAll("rgb(", "")
          .replaceAll("rgba(", "")
          .replaceAll(")", "");

      List<String> rgbSplit = numParts.split(",").map((e) => e.trim()).toList();

      int r = int.parse( rgbSplit[0] );
      int g = int.parse( rgbSplit[1] );
      int b = int.parse( rgbSplit[2] );

      double a = hasAlpha
          ? double.parse( rgbSplit[3] )
          : 1.0;

      return Color.fromRGBO( r, g, b, a );

    } catch( e ) {
      return fallback;
    }
  }

}

class UIColor extends Color {
  UIColor( dynamic value, { Color fallback = Colors.transparent } ) : super
      (
      UIColorManager()._parse(
        value,
        fallback: Colors.transparent,
      ).value,
    );
}
