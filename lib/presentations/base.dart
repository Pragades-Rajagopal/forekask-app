import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/favorites_page.dart';
import 'package:forekast_app/presentations/settings_page.dart';
import 'package:forekast_app/presentations/weather_page.dart';
import 'package:forekast_app/presentations/widgets/cities_search_sheet.dart';
import 'package:forekast_app/utils/common_ui.dart';
import 'package:forekast_app/utils/themes.dart';
import 'package:get/get.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late final PageController _pageController = PageController();
  var _currentIndex = 0;
  final GlobalKey _key = GlobalKey();
  GlobalKey searchKey = GlobalKey();
  final textController = TextEditingController();
  var currentLocation = '';
  BorderRadius searchBarRadius = BorderRadius.circular(30.0);
  List<String> citiesData = [];
  List<String> filteredCities = [];

  final _weatherNotifier = ValueNotifier<String>('');

  // Appbar titles
  static final List<String> _titles = [
    'forekast',
    'favorites',
  ];

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    await getLocation();
  }

  Future<void> getLocation() async {
    final defaultLocation = await CitiesData.getDefaultCity();
    // Current/ default location to be shown in favorites page
    setState(() {
      currentLocation = defaultLocation!;
    });
    String defaultCity = await FavoritesData.getDefaultFavorite();
    if (defaultCity != '') {
      setState(() {
        _weatherNotifier.value = defaultCity;
      });
    } else if (defaultLocation != '' || defaultLocation != null) {
      setState(() {
        _weatherNotifier.value = defaultLocation ?? '';
      });
    }
  }

  void _updateSelectedCity(String city) {
    setState(() {
      _weatherNotifier.value = city;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: _appBar(title: _titles[_currentIndex], index: _currentIndex),
      key: _key,
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          WeatherPage(
            key: ValueKey('WeatherPage$_currentIndex'),
            selectedCity: _weatherNotifier,
          ),
          FavoritesPage(
            key: const ValueKey('FavoritesPage'),
            onCitySelected: _updateSelectedCity,
            currentLocation: currentLocation,
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: bottomNavBarTheme,
        child: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(microseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          elevation: 0,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.95),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          iconSize: 28.0,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: bottomNavBarItems,
        ),
      ),
    );
  }

  AppBar _appBar({title = 'forekast', index = 0}) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
      actions: [
        if (index == 0) ...{
          CitiesSearchSheet(
            usageType: 'search',
            onValueChanged: _updateSelectedCity,
          ),
        } else if (index == 1) ...{
          TextButton(
            onPressed: () {
              Get.to(() => const SettingsPage());
            },
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.fromLTRB(0, 4, 18, 0),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            child: const Icon(
              Icons.settings,
            ),
          ),
        }
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weatherNotifier.dispose();
    super.dispose();
  }
}
