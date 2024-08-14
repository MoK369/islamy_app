import 'package:flutter/widgets.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BgContainer extends StatelessWidget {
  final Widget child;

  const BgContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.isDarkEnabled();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(isDark
                  ? 'assets/images/bg_dark.png'
                  : 'assets/images/bg.png'),
              fit: BoxFit.fill)),
      child: child,
    );
  }
}
