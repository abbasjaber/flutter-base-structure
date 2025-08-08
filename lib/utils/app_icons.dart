import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  // Base path for SVG icons
  static const String _svgPath = 'assets/icons/SVG/';

  // Icon paths
  static const String camera = '${_svgPath}Asset 590.svg';
  static const String checkmark = '${_svgPath}Asset 589.svg';
  static const String store = '${_svgPath}Asset 519.svg';
  static const String user = '${_svgPath}Asset 536.svg';
  static const String home = '${_svgPath}Asset 577.svg';
  static const String settings = '${_svgPath}Asset 506.svg';
  static const String logout = '${_svgPath}Asset 563.svg';
  static const String analytics = '${_svgPath}Asset 582.svg';
  static const String history = '${_svgPath}Asset 583.svg';
  static const String phone = '${_svgPath}Asset 581.svg';
  static const String location = '${_svgPath}Asset 542.svg';
  static const String document = '${_svgPath}Asset 580.svg';
  static const String shoppingCart = '${_svgPath}Asset 578.svg';
  static const String payment = '${_svgPath}Asset 577.svg';
  static const String people = '${_svgPath}Asset 575.svg';
  static const String qrCode = '${_svgPath}Asset 576.svg';
  static const String receipt = '${_svgPath}Asset 572.svg';
  static const String map = '${_svgPath}Asset 578.svg';
  static const String business = '${_svgPath}Asset 574.svg';
  static const String refresh = '${_svgPath}Asset 573.svg';
  static const String more = '${_svgPath}Asset 572.svg';
  static const String navigation = '${_svgPath}Asset 583.svg';
  static const String currentLocation = '${_svgPath}Asset 580.svg';
  static const String route = '${_svgPath}Asset 495.svg';

  // Helper method to get SVG icon with custom color
  static Widget svgIcon({
    required String path,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      fit: fit,
    );
  }

  // Predefined icon widgets with PRIME theme colors
  static Widget cameraIcon({double? size, Color? color}) {
    return svgIcon(
      path: camera,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget checkmarkIcon({double? size, Color? color}) {
    return svgIcon(
      path: checkmark,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget storeIcon({double? size, Color? color}) {
    return svgIcon(
      path: store,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget userIcon({double? size, Color? color}) {
    return svgIcon(
      path: user,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget homeIcon({double? size, Color? color}) {
    return svgIcon(
      path: home,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget settingsIcon({double? size, Color? color}) {
    return svgIcon(
      path: settings,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget logoutIcon({double? size, Color? color}) {
    return svgIcon(
      path: logout,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget analyticsIcon({double? size, Color? color}) {
    return svgIcon(
      path: analytics,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget historyIcon({double? size, Color? color}) {
    return svgIcon(
      path: history,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget phoneIcon({double? size, Color? color}) {
    return svgIcon(
      path: phone,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget locationIcon({double? size, Color? color}) {
    return svgIcon(
      path: location,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget documentIcon({double? size, Color? color}) {
    return svgIcon(
      path: document,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget shoppingCartIcon({double? size, Color? color}) {
    return svgIcon(
      path: shoppingCart,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget paymentIcon({double? size, Color? color}) {
    return svgIcon(
      path: payment,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget peopleIcon({double? size, Color? color}) {
    return svgIcon(
      path: people,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget qrCodeIcon({double? size, Color? color}) {
    return svgIcon(
      path: qrCode,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget receiptIcon({double? size, Color? color}) {
    return svgIcon(
      path: receipt,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget mapIcon({double? size, Color? color}) {
    return svgIcon(
      path: map,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget businessIcon({double? size, Color? color}) {
    return svgIcon(
      path: business,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget refreshIcon({double? size, Color? color}) {
    return svgIcon(
      path: refresh,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget moreIcon({double? size, Color? color}) {
    return svgIcon(
      path: more,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget navigationIcon({double? size, Color? color}) {
    return svgIcon(
      path: navigation,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget currentLocationIcon({double? size, Color? color}) {
    return svgIcon(
      path: currentLocation,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget routeIcon({double? size, Color? color}) {
    return svgIcon(
      path: route,
      width: size,
      height: size,
      color: color,
    );
  }
}
