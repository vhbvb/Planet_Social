import 'package:flutter/material.dart';

class PSProcess {
  static final shared = PSProcess();
  BuildContext context;

  static show(BuildContext context) {
    PSProcess.shared.context = context;
    // Navigator.of(context).push(_NoAnimationMaterialPageRoute(builder: (_){
    //   return _Indicator();
    // }));

    showDialog(context: context, builder: (_) => _Indicator());
  }

  static dismiss(BuildContext context) {
    if (PSProcess.shared.context == context) {
      Navigator.of(PSProcess.shared.context).pop();
      PSProcess.shared.context = null;
    }
  }
}

// class _NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
//   _NoAnimationMaterialPageRoute({
//     @required WidgetBuilder builder,
//     RouteSettings settings,
//     bool maintainState = true,
//     bool fullscreenDialog = false,
//   }) : super(
//             builder: builder,
//             maintainState: maintainState,
//             settings: settings,
//             fullscreenDialog: fullscreenDialog);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }

class _Indicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IndicatorState();
}

class _IndicatorState extends State<_Indicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.2,
        ),
        Center(
          child: SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(backgroundColor: Colors.orange)),
        )
      ],
    );
  }
}
