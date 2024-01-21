import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

/// Inspiration taken from [modal_bottom_sheet](https://github.com/jamesblasco/modal_bottom_sheet)
class _CupertinoBottomSheetContainer extends StatelessWidget {
  /// Widget to render
  final Widget child;
  final Color backgroundColor;

  /// Add padding to the top of [child], this is also the height of visible
  /// content behind [child]
  ///
  /// Defaults to 10
  final double topPadding;
  const _CupertinoBottomSheetContainer({
    required Key key,
    required this.child,
    required this.backgroundColor,
    required this.topPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = this.topPadding + topSafeAreaPadding;
    const radius = Radius.circular(12);
    const shadow =
        BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 5);
    final backgroundColor = this.backgroundColor;

    final decoration =
        BoxDecoration(color: backgroundColor, boxShadow: const [shadow]);

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.only(topLeft: radius, topRight: radius),
        child: Container(
          decoration: decoration,
          width: double.infinity,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true, // Remove top Safe Area
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Inspiration taken from [modal_bottom_sheet](https://github.com/jamesblasco/modal_bottom_sheet)
class _CupertinoModalTransition extends StatelessWidget {
  /// Animation that [child] will use for entry or leave
  final Animation<double> animation;

  /// Animation curve to be applied to [animation]
  ///
  /// Defaults to [Curves.easeOut]
  final Curve animationCurve;

  /// Widget that will be displayed at the top
  final Widget child;

  /// Widget that will be displayed behind [child]
  ///
  /// Usually this is the route that shows this model
  final Widget behindChild;

  const _CupertinoModalTransition({
    required Key key,
    required this.animation,
    required this.child,
    required this.behindChild,
    required this.animationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startRoundCorner = 0.0;
    final paddingTop = MediaQuery.of(context).padding.top;
    if (Theme.of(context).platform == TargetPlatform.iOS && paddingTop > 20) {
      startRoundCorner = 38.5;
      // See: https://kylebashour.com/posts/finding-the-real-iphone-x-corner-radius
    }

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: animationCurve ?? Curves.easeOut,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      /// Because the first element of the stack below is a black coloured
      /// container, this is required
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: curvedAnimation,
        child: child,
        builder: (context, child) {
          final progress = curvedAnimation.value;
          final yOffset = progress * paddingTop;
          final scale = 1 - progress / 10;
          final radius = progress == 0
              ? 0.0
              : (1 - progress) * startRoundCorner + progress * 12;
          return Stack(
            children: [
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(color: Colors.black),
              ),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Transform.translate(
                  offset: Offset(0, yOffset),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: behindChild,
                    ),
                  ),
                ),
              ),
              child ?? Container(), // TODO: remove ??
            ],
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CupertinoFullscreenDialog Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        key: const Key('home'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  /// Builds this widget with it's own context and configuration
  /// This allows the background to be interactive and depict live state
  Widget get $thisWidget => build(context);

  /// Try setting it to true and see that the default transition from
  /// MaterialPageRoute is combined with [CupertinoFullscreenDialogTransition]
  /// By default material pages use [FadeUpwardsPageTransitionsBuilder]
  bool inheritRouteTransition = false;

  // For production the correct value should be between 400 milliseconds and 1 second
  Duration transitionDuration = const Duration(seconds: 1);

  /// Uses the nearest route to build a transition to [child]
  Widget buildRouteTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    /// Using [this.context] instead of the provided [context]
    /// allows us to make sure we use the route that [this.widget] is being
    /// displayed in instead of the route that our modal will be displayed in
    final route = ModalRoute.of(this.context);

    return route?.buildTransitions(
          context,
          animation,
          secondaryAnimation,
          child,
        ) ??
        Container();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'Settings',
      barrierColor: Colors.black,
      context: context,
      transitionDuration: transitionDuration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _CupertinoModalTransition(
          animation: animation,
          behindChild: $thisWidget,
          key: const Key('general'),
          animationCurve: Curves.easeOut,
          child: !inheritRouteTransition
              ? child
              : buildRouteTransition(
                  context, animation, secondaryAnimation, child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return CupertinoFullscreenDialogTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: true,
          child: const CupertinoDialogBody(key: Key('transition')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
                'Transition duration: ${transitionDuration.inSeconds} seconds'),
            Slider.adaptive(
              label: 'Transition duration',
              divisions: 5,
              value: transitionDuration.inSeconds * 1.0,
              min: 1,
              max: 10,
              onChanged: (val) {
                setState(() {
                  transitionDuration = Duration(seconds: val.toInt());
                });
              },
            ),
            const Text('Inherit route transition?'),
            Switch.adaptive(
              value: inheritRouteTransition,
              onChanged: (state) =>
                  setState(() => inheritRouteTransition = state),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CupertinoDialogBody extends StatefulWidget {
  const CupertinoDialogBody({
    required Key key,
  }) : super(key: key);

  @override
  _CupertinoDialogBodyState createState() => _CupertinoDialogBodyState();
}

class _CupertinoDialogBodyState extends State<CupertinoDialogBody> {
  /// Prevent further popping of navigator stack once dialog is popped
  bool isDialogPopped = false;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      /// Only allow to be scrolled down up to half size of the child
      minChildSize: 0.50,

      /// Show full screen by default
      initialChildSize: 1,
      builder: (context, controller) {
        return _CupertinoBottomSheetContainer(
          key: const Key('draggable'),
          backgroundColor: Colors.black,
          topPadding: 15,
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (DraggableScrollableNotification notification) {
              if (!isDialogPopped &&
                  notification.extent == notification.minExtent) {
                isDialogPopped = true;
                Navigator.of(context).pop();
              }
              return false;
            },
            child: CupertinoApp(
              debugShowCheckedModeBanner: false,
              home: CustomScrollView(
                controller: controller,
                shrinkWrap: false,
                slivers: [
                  CupertinoSliverNavigationBar(
                    backgroundColor: Colors.grey[200],
                    largeTitle: Text(
                      'Settings',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle,
                    ),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Done',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navActionTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 50.0,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.lightBlue[100 * (index % 9)],
                          child: Text('List Item ${index + 1}'),
                        );
                      },
                      childCount: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
