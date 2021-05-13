import 'package:flutter/material.dart';
import 'package:xl/xl.dart';

import '../components/info.dart';
import '../components/objects.dart';
import '../components/waves.dart';

const drag = Duration(milliseconds: 1800);
const curve = Curves.easeOutQuint;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ParallaxStack(
          dragging: Dragging(duration: drag, curve: curve),
          normalization: Normalization(scalar: [2.0, 2.0]),
          layers: const [
            BackgroundLayer(),
            Shade(color: Colors.black45),
            Wave3(),
            Shade(color: Colors.black38),
            Scribbles(),
            Wave2(),
            Shade(),
            Wave1(),
            Sign(),
            MoreInfo(),
          ],
        ),
      );
}
