import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/favorites_page.dart';
import 'package:forekast_app/presentations/settings_page.dart';
import 'package:forekast_app/presentations/weather_page.dart';
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
  var searchCity = 'oslo';
  BorderRadius searchBarRadius = BorderRadius.circular(30.0);
  List<String> citiesData = [];
  List<String> filteredCities = [];

  final _weatherNotifier = ValueNotifier<String>('oslo');

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
    String defaultCity = await FavoritesData.getDefaultFavorite();
    if (defaultCity != '') {
      setState(() {
        _weatherNotifier.value = defaultCity;
      });
    }
    await getCitiesFunc();
  }

  void _updateSelectedCity(String city) {
    setState(() {
      _weatherNotifier.value = city;
    });
    _pageController.jumpToPage(0);
  }

  Future<void> getCitiesFunc() async {
    List<String>? data = await CitiesData.getCities();
    setState(() {
      citiesData.addAll(data!);
    });
  }

  void filterCities(String query, StateSetter setState) {
    if (query.isEmpty) {
      setState(() {
        filteredCities.clear();
      });
      return;
    }
    setState(() {
      filteredCities = citiesData
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .take(30)
          .toList();
    });
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
          ),
        ],
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
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.95),
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
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
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
        } else if (index == 1) ...{
          TextButton(
            onPressed: () {
              Get.to(() => const SettingsPage());
            },
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.fromLTRB(0, 4, 18, 0),
              ),
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
            ),
            child: const Icon(
              Icons.settings,
            ),
          ),
        }
      ],
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
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 360,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: TextField(
                                key: searchKey,
                                controller: textController,
                                decoration: InputDecoration(
                                  // contentPadding: const EdgeInsets.all(10.0),
                                  hintText: 'search city',
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: searchBarRadius,
                                    borderSide: const BorderSide(
                                        width: 0.0, color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: searchBarRadius,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white12,
                                  prefixIcon: IconButton(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    icon: const Icon(Icons.clear),
                                    style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        textController.text = '';
                                        filteredCities.clear();
                                      });
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    icon: const Icon(Icons.search),
                                    style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context, textController.text);
                                      setState(() {
                                        textController.text = '';
                                        filteredCities.clear();
                                      });
                                    },
                                  ),
                                ),
                                cursorColor:
                                    Theme.of(context).colorScheme.secondary,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onChanged: (value) {
                                  filterCities(value, setState);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, filteredCities[index]);
                            setState(() {
                              filteredCities.clear();
                              textController.text = '';
                            });
                          },
                          child: Card(
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            shape: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Container(
                              color: Theme.of(context).colorScheme.background,
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredCities[index],
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.fontSize,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((selectedCity) => {
          if (selectedCity != null)
            {
              setState(() {
                searchCity = selectedCity;
                _weatherNotifier.value = selectedCity;
              })
            }
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weatherNotifier.dispose();
    super.dispose();
  }
}
