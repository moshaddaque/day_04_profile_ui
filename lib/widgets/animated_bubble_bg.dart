// import 'dart:math';
// import 'package:flutter/material.dart';

// class AnimatedBubbleBackground extends StatefulWidget {
//   final Widget child;
//   final int bubbleCount;
//   final List<Color>? bubbleColors;
//   final double minBubbleSize;
//   final double maxBubbleSize;
//   final Duration animationDuration;

//   const AnimatedBubbleBackground({
//     Key? key,
//     required this.child,
//     this.bubbleCount = 15,
//     this.bubbleColors,
//     this.minBubbleSize = 20.0,
//     this.maxBubbleSize = 80.0,
//     this.animationDuration = const Duration(seconds: 20),
//   }) : super(key: key);

//   @override
//   State<AnimatedBubbleBackground> createState() =>
//       _AnimatedBubbleBackgroundState();
// }

// class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground>
//     with TickerProviderStateMixin {
//   late List<AnimationController> _controllers;
//   late List<Animation<Offset>> _animations;
//   late List<Bubble> _bubbles;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBubbles();
//   }

//   void _initializeBubbles() {
//     _controllers = [];
//     _animations = [];
//     _bubbles = [];

//     final random = Random();

//     for (int i = 0; i < widget.bubbleCount; i++) {
//       // Create animation controller for each bubble
//       final controller = AnimationController(
//         duration: Duration(
//           seconds: widget.animationDuration.inSeconds + random.nextInt(10) - 5,
//         ),
//         vsync: this,
//       );

//       // Random start and end positions
//       final startX = random.nextDouble() * 2 - 0.5; // -0.5 to 1.5
//       final startY = 1.2 + random.nextDouble() * 0.5; // Start below screen
//       final endX = random.nextDouble() * 2 - 0.5;
//       final endY = -0.5 - random.nextDouble() * 0.5; // End above screen

//       final animation = Tween<Offset>(
//         begin: Offset(startX, startY),
//         end: Offset(endX, endY),
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

//       // Create bubble data
//       final bubble = Bubble(
//         size:
//             widget.minBubbleSize +
//             random.nextDouble() * (widget.maxBubbleSize - widget.minBubbleSize),
//         color:
//             widget.bubbleColors?[random.nextInt(widget.bubbleColors!.length)] ??
//             _getRandomColor(),
//         opacity: 0.1 + random.nextDouble() * 0.4, // 0.1 to 0.5
//       );

//       _controllers.add(controller);
//       _animations.add(animation);
//       _bubbles.add(bubble);

//       // Start animation with random delay
//       Future.delayed(Duration(milliseconds: random.nextInt(5000)), () {
//         if (mounted) {
//           _startBubbleAnimation(i);
//         }
//       });
//     }
//   }

//   void _startBubbleAnimation(int index) {
//     final controller = _controllers[index];
//     final random = Random();

//     controller.forward().then((_) {
//       if (mounted) {
//         // Reset bubble position and properties
//         final startX = random.nextDouble() * 2 - 0.5;
//         final startY = 1.2 + random.nextDouble() * 0.5;
//         final endX = random.nextDouble() * 2 - 0.5;
//         final endY = -0.5 - random.nextDouble() * 0.5;

//         _animations[index] = Tween<Offset>(
//           begin: Offset(startX, startY),
//           end: Offset(endX, endY),
//         ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

//         // Update bubble properties
//         _bubbles[index] = Bubble(
//           size:
//               widget.minBubbleSize +
//               random.nextDouble() *
//                   (widget.maxBubbleSize - widget.minBubbleSize),
//           color:
//               widget.bubbleColors?[random.nextInt(
//                 widget.bubbleColors!.length,
//               )] ??
//               _getRandomColor(),
//           opacity: 0.1 + random.nextDouble() * 0.4,
//         );

//         controller.reset();

//         // Add small delay before next cycle
//         Future.delayed(Duration(milliseconds: random.nextInt(2000)), () {
//           if (mounted) {
//             _startBubbleAnimation(index);
//           }
//         });
//       }
//     });
//   }

//   Color _getRandomColor() {
//     final random = Random();
//     final colors = [
//       Colors.blue,
//       Colors.purple,
//       Colors.pink,
//       Colors.cyan,
//       Colors.teal,
//       Colors.indigo,
//       Colors.deepPurple,
//     ];
//     return colors[random.nextInt(colors.length)];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Animated bubbles layer
//         Positioned.fill(
//           child: CustomPaint(
//             painter: BubblePainter(animations: _animations, bubbles: _bubbles),
//           ),
//         ),
//         // Child content
//         widget.child,
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     for (final controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
// }

// class Bubble {
//   final double size;
//   final Color color;
//   final double opacity;

//   Bubble({required this.size, required this.color, required this.opacity});
// }

// class BubblePainter extends CustomPainter {
//   final List<Animation<Offset>> animations;
//   final List<Bubble> bubbles;

//   BubblePainter({required this.animations, required this.bubbles})
//     : super(repaint: Listenable.merge(animations));

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (int i = 0; i < animations.length; i++) {
//       final animation = animations[i];
//       final bubble = bubbles[i];
//       final position = animation.value;

//       final x = position.dx * size.width;
//       final y = position.dy * size.height;

//       // Skip if bubble is outside visible area
//       if (x < -bubble.size ||
//           x > size.width + bubble.size ||
//           y < -bubble.size ||
//           y > size.height + bubble.size) {
//         continue;
//       }

//       final paint =
//           Paint()
//             ..shader = RadialGradient(
//               colors: [
//                 bubble.color.withOpacity(bubble.opacity),
//                 bubble.color.withOpacity(bubble.opacity * 0.3),
//                 bubble.color.withOpacity(0.0),
//               ],
//               stops: const [0.0, 0.7, 1.0],
//             ).createShader(
//               Rect.fromCircle(center: Offset(x, y), radius: bubble.size / 2),
//             );

//       canvas.drawCircle(Offset(x, y), bubble.size / 2, paint);

//       // Add shimmer effect
//       final shimmerPaint =
//           Paint()
//             ..color = Colors.white.withOpacity(bubble.opacity * 0.3)
//             ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

//       canvas.drawCircle(
//         Offset(x - bubble.size * 0.15, y - bubble.size * 0.15),
//         bubble.size * 0.2,
//         shimmerPaint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
