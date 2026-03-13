import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class PinchZoomWidget extends StatefulWidget {
  final Widget child;

  const PinchZoomWidget({super.key, required this.child});

  @override
  State<PinchZoomWidget> createState() => _PinchZoomWidgetState();
}

class _PinchZoomWidgetState extends State<PinchZoomWidget>
    with SingleTickerProviderStateMixin {
  Matrix4 _matrix = Matrix4.identity();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  bool _isZooming = false;

  double _currentScale = 1.0;
  Offset _startFocalPoint = Offset.zero;
  Offset _lastOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        if (_animation != null) {
          setState(() {
            _matrix = _animation!.value;
          });
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isZooming = false;
            _currentScale = 1.0;
            _lastOffset = Offset.zero;
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _animationController.stop();
    _startFocalPoint = details.focalPoint;
    setState(() {
      _isZooming = true;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    double newScale = (_currentScale * details.scale).clamp(1.0, 4.0);

    final focalDelta = details.focalPoint - _startFocalPoint;
    final offset = _lastOffset + focalDelta;

    setState(() {
      _matrix = Matrix4.identity()
        ..translateByVector3(vm.Vector3(offset.dx, offset.dy, 0))
        ..scaleByVector3(vm.Vector3(newScale, newScale, 1));
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _animation = Matrix4Tween(
      begin: _matrix,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: ClipRect(
        clipBehavior: _isZooming ? Clip.none : Clip.hardEdge,
        child: Transform(
          transform: _matrix,
          alignment: FractionalOffset.center,
          child: widget.child,
        ),
      ),
    );
  }
}
