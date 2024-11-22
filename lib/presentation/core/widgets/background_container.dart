import 'package:flutter/widgets.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BgContainer extends StatelessWidget {
  final Widget child;

  const BgContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(themeProvider.isDarkEnabled()
                  ? 'assets/images/bg_dark.png'
                  : 'assets/images/bg.png'),
              fit: BoxFit.fill)),
      child: child,
    );
  }
}
