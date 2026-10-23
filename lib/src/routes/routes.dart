import 'package:flutter/cupertino.dart';

import '../pages/addname_page.dart';
import '../pages/editname_page.dart';
import '../pages/home_page.dart';

Map<String, WidgetBuilder> getAplicationsRoutes() => <String, WidgetBuilder>{
  '/': (context) => const HomePage(),
  '/add': (context) => const AddNamePage(),
  '/edit': (context) => const EditNamePage(),
};
