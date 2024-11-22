import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
import 'package:forekast_app/presentations/widgets/gesture_button.dart';
import 'package:forekast_app/presentations/widgets/rich_text.dart';
import 'package:forekast_app/utils/common_ui.dart';
import 'package:get/get.dart';

class CitiesSearchSheet extends StatefulWidget {
  final String usageType;
  final Function(String) onValueChanged;
  const CitiesSearchSheet({
    super.key,
    required this.usageType,
    required this.onValueChanged,
  });

  @override
  CitiesSearchSheetState createState() => CitiesSearchSheetState();
}

class CitiesSearchSheetState extends State<CitiesSearchSheet> {
  CitiesData citiesDataModel = CitiesData();
  LocationData locationData = LocationData();
  GlobalKey searchKey = GlobalKey();
  final textController = TextEditingController();
  List<String> citiesData = [];
  List<String> filteredCities = [];
  bool _searchTextChanged = false;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    await getCitiesFunc();
  }

  void openCitySearchSheet() => _searchBottomSheet();

  Future<void> getCitiesFunc() async {
    List<String>? data = await citiesDataModel.getCities();
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

  void _searchBottomSheet() {
    BorderRadius searchBarRadius = BorderRadius.circular(30.0);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              height: MediaQuery.of(context).size.height * 0.89,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      width: 380,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: TextField(
                          key: searchKey,
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'search city',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: searchBarRadius,
                              borderSide: const BorderSide(
                                width: 0.0,
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: searchBarRadius,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white12,
                            suffixIcon: IconButton(
                              color: Theme.of(context).colorScheme.secondary,
                              icon: const Icon(CupertinoIcons.delete_left),
                              style: const ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  textController.text = '';
                                  filteredCities.clear();
                                });
                              },
                            ),
                            prefixIcon: IconButton(
                              color: Theme.of(context).colorScheme.secondary,
                              icon: const Icon(Icons.search),
                              style: const ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                              ),
                              onPressed: () {
                                Navigator.pop(context, textController.text);
                                setState(() {
                                  textController.text = '';
                                  filteredCities.clear();
                                });
                              },
                            ),
                          ),
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onChanged: (value) {
                            setState(() => _searchTextChanged = true);
                            filterCities(value, setState);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    if (filteredCities.isEmpty) ...{
                      getMessage(context),
                    },
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
                              _searchTextChanged = false;
                            });
                          },
                          child: Card(
                            elevation: 0.0,
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 5.0,
                            ),
                            child: Container(
                              color: Theme.of(context).colorScheme.surface,
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    context,
                                    filteredCities[index],
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.fontSize,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
    ).then((selectedCity) async {
      if (selectedCity != null && widget.usageType == 'landing_page') {
        final weatherNotifier = ValueNotifier<String>('');
        final city = selectedCity.toString().trim();
        await locationData.storeManualCity(city);
        setState(() {
          weatherNotifier.value = city;
          _searchTextChanged = false;
        });
        Get.offAll(
          () => BasePage(
            weatherNotifier: weatherNotifier,
          ),
        );
      } else if (selectedCity != null) {
        final city = selectedCity.toString().trim();
        setState(() {
          widget.onValueChanged(city);
          _searchTextChanged = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.usageType == 'landing_page') {
      return GestureButton(
        onTap: openCitySearchSheet,
        buttonText: 'choose city manually',
      );
    } else {
      return TextButton(
        onPressed: () {
          _searchBottomSheet();
        },
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.fromLTRB(0, 4, 18, 0),
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        child: const Icon(
          CupertinoIcons.globe,
        ),
      );
    }
  }

  /// Show messages when the sheet is opened and on typed
  Widget getMessage(BuildContext context) {
    return SizedBox(
      width: 380.0,
      child: RichTextWidget(
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
        inlineSpans: _searchTextChanged
            ? const [
                TextSpan(text: "city not found? Try hitting "),
                WidgetSpan(child: Icon(CupertinoIcons.search, size: 16)),
              ]
            : const [
                TextSpan(text: "search "),
                TextSpan(
                  text: "Oslo,NO",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      " for example (country code will help provide exact location)",
                ),
              ],
      ),
    );
  }
}
