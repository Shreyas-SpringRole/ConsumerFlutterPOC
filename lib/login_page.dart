import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'common/animated_gradient.dart';
import 'common/locator.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final username = useTextEditingController();
    final password = useTextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            LoginMasthead(),
            LoginTextField(
              controller: username,
              hintText: 'hello@gmail.com',
              labelText: 'Username',
              obscureText: false,
              suffixIcon: Icons.people,
            ),
            LoginTextField(
              controller: password,
              hintText: '',
              labelText: 'Password',
              obscureText: true,
              suffixIcon: Icons.remove_red_eye,
            ),
            LoginButton(),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

class LoginMasthead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HomeClipper(),
      child: Container(
        width: double.infinity,
        height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(iMowzMasthead, fit: BoxFit.cover)),
            Positioned(left: 20, right: 20, child: Image.asset(iLogo)),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData suffixIcon;
  final bool obscureText;

  const LoginTextField(
      {Key key,
      this.controller,
      this.hintText,
      this.labelText,
      this.suffixIcon,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
          labelText: labelText,
          suffixIcon: Icon(suffixIcon),
        ),
        obscureText: obscureText,
      ),
    );
  }
}

class HomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    return Path()
      ..lineTo(0, height)
      ..cubicTo(0, height * .7, width, height * .8, width, height * .55)
      ..lineTo(width, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LoginButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => sl<NavigationManager>().root(HomeRoute),
      child: ClipPath(
        clipper: LoginButtonClipper(),
        child: PlowzGradient(
          type: PlowzGradientType.light,
          width: 135,
          height: 135,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum PlowzGradientType { light, regular }

class PlowzGradient extends HookWidget {
  final PlowzGradientType type;
  final Widget child;
  final double width;
  final double height;

  PlowzGradient(
      {this.type = PlowzGradientType.regular,
      this.child,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    final gradient = useAnimatedGradient(gradients: [
      LinearGradient(colors: [
        type == PlowzGradientType.light ? Colors.green[100] : Colors.green,
        Colors.green[700],
      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      LinearGradient(colors: [
        type == PlowzGradientType.light ? Colors.blue[100] : Colors.blue,
        Colors.blue[700],
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ], curve: Curves.easeInOut);
    return Container(
        width: width,
        height: height,
        child: child,
        decoration: BoxDecoration(
          gradient: gradient,
        ));
  }
}

class LoginButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, 10)
      ..quadraticBezierTo(-40, size.height / 2, size.width, size.height - 10);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
