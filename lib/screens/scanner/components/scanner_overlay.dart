import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  final Color overlayColor;
  final Color scanLineColor;

  const ScannerOverlay({
    Key? key,
    this.overlayColor = Colors.black87,
    this.scanLineColor = const Color(0xFF2196F3),
  }) : super(key: key);

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanAreaSize = MediaQuery.of(context).size.width * 0.7;

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.overlayColor,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.5),
                child: Container(
                  height: scanAreaSize,
                  width: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.5),
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ...List.generate(4, (index) {
                  final isRight = index == 1 || index == 3;
                  final isBottom = index == 2 || index == 3;
                  return _buildCorner(isRight, isBottom);
                }),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: _animation.value * scanAreaSize,
                      child: Container(
                        width: scanAreaSize,
                        height: 3,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: widget.scanLineColor.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              widget.scanLineColor.withOpacity(0),
                              widget.scanLineColor,
                              widget.scanLineColor.withOpacity(0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(bool isRight, bool isBottom) {
    return Positioned(
      left: isRight ? null : -2,
      right: isRight ? -2 : null,
      top: isBottom ? null : -2,
      bottom: isBottom ? -2 : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            left: isRight
                ? BorderSide.none
                : BorderSide(color: widget.scanLineColor, width: 4),
            top: isBottom
                ? BorderSide.none
                : BorderSide(color: widget.scanLineColor, width: 4),
            right: isRight
                ? BorderSide(color: widget.scanLineColor, width: 4)
                : BorderSide.none,
            bottom: isBottom
                ? BorderSide(color: widget.scanLineColor, width: 4)
                : BorderSide.none,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.scanLineColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
