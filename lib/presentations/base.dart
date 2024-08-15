import 'package:flutter/material.dart';
import 'package:forekast_app/presentations/favorites_page.dart';
import 'package:forekast_app/presentations/weather_page.dart';
import 'package:forekast_app/utils/common.dart';
import 'package:forekast_app/utils/themes.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late final PageController _pageController = PageController();
  var _currentIndex = 0;
  final GlobalKey _key = GlobalKey();

  // App pages as widgets
  static final List<Widget> _widget = [
    const WeatherPage(),
    const FavoritesPage(),
  ];

  // Appbar titles
  static final List<String> _titles = [
    'forekast',
    'favorites',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(title: _titles[_currentIndex]),
      key: _key,
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _widget,
      ),
      bottomNavigationBar: Theme(
        data: bottomNavBarTheme,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(microseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          iconSize: 28.0,
          selectedFontSize: 14.0,
          unselectedFontSize: 14.0,
          items: bottomNavBarItems,
        ),
      ),
    );
  }

  AppBar _appBar({title = 'forekast', index = 0}) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      actions: [
        if (index == 0) ...{
          TextButton(
            onPressed: () {
              _searchBottomSheet(context, _key);
            },
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.fromLTRB(0, 4, 18, 0),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
            ),
            child: const Icon(
              Icons.search,
            ),
          ),
        }
      ],
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 0, 0),
        child: IconButton(
          tooltip: 'Settings',
          onPressed: () {},
          icon: const Icon(
            Icons.settings,
            // size: 20,
          ),
          alignment: Alignment.center,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    );
  }

  void _searchBottomSheet(BuildContext context, GlobalKey key) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Do you wish to delete this note permanently?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () async {},
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 14.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
