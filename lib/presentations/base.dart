import 'package:flutter/cupertino.dart';
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
  final ValueNotifier<String> weatherNotifier;
  final String? routeType;
  const BasePage({
    super.key,
    required this.weatherNotifier,
    this.routeType,
  });

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
  FavoritesData favoritesData = FavoritesData();
  LocationData locationData = LocationData();

  // Appbar titles
  static final List<String> _titles = [
    'forekast',
    'favorites',
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final defaultLocation = await locationData.getManualCity();
    // Current/ default location to be shown in favorites page
    if (defaultLocation.isNotEmpty) {
      setState(() => currentLocation = defaultLocation);
    } else {
      setState(() => currentLocation = widget.weatherNotifier.value);
    }
    final favoriteAsDefaultCity = await favoritesData.getDefaultFavorite();
    if (favoriteAsDefaultCity.isNotEmpty) {
      setState(() {
        widget.weatherNotifier.value = favoriteAsDefaultCity;
      });
    }
  }

  void _updateSelectedCity(String city) {
    setState(() {
      widget.weatherNotifier.value = city;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            selectedCity: widget.weatherNotifier,
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
              CupertinoIcons.gear_solid,
            ),
          ),
        }
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.weatherNotifier.dispose();
    super.dispose();
  }
}
