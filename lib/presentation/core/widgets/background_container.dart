import 'package:flutter/widgets.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
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
                  ? AssetsPaths.bgDarkImage
                  : AssetsPaths.bgImage),
              fit: BoxFit.fill)),
      child: child,
    );
  }
}
