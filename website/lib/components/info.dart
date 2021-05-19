import 'package:flutter/material.dart';
import 'package:xl/xl.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatelessWidget {
  const MoreInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AcceleraxLayer(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 75,
                    fontFamily: 'Quicksand',
                    shadows: [Shadow(blurRadius: 15, color: Colors.black)],
                  ),
                  children: [
                    TextSpan(
                      text: 'xl',
                      style: TextStyle(
                        color: Colors.lightBlue.shade100,
                        fontWeight: FontWeight.w900,
                        fontSize: 125,
                      ),
                    ),
                    const TextSpan(text: '.dart'),
                  ]),
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_box_outlined, size: 40),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => MoreInfoDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoreInfoDialog extends StatelessWidget {
  const MoreInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Material(
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'WELCOME TO THE XL STACK',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
                const Text('a parallax-based animation package'),
                const SizedBox(height: 10),
                Text(
                  'The goal of this package is to make accelerometer- and '
                  'mouse or touch-fueled parallax effects as simple as possible.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: const EdgeInsets.all(3.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text(
                      'import "package:xl/xl.dart"',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => launch('https://pub.dev/packages/xl'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
