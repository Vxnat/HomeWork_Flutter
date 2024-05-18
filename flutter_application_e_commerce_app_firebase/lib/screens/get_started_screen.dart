import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/auth/login_or_register.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Image.asset(
                  'img/logo.png',
                  width: 250,
                  height: 250,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: 'Vxnat',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 102, 0),
                                fontSize: 25)),
                        TextSpan(
                            text: 'Food',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 102, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 30))
                      ]))
                    ],
                  ),
                ),
                const Text(
                  'Good food for good life',
                  style: TextStyle(color: Colors.orange, fontSize: 13),
                )
              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        // Màu nền khi hover vào
                        return const Color.fromARGB(255, 255, 187, 85);
                      }
                      // Màu nền mặc định
                      return Colors.white;
                    }),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 102, 0),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginOrRegister(),
                    ));
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 102, 0),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
