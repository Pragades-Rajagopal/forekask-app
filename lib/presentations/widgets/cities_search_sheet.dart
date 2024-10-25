import 'package:flutter/material.dart';
import 'package:forekast_app/data/local_storage/local_data.dart';
import 'package:forekast_app/presentations/base.dart';
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
  GlobalKey searchKey = GlobalKey();
  final textController = TextEditingController();
  List<String> citiesData = [];
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    await getCitiesFunc();
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
                                      overlayColor: WidgetStatePropertyAll(
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
                                      overlayColor: WidgetStatePropertyAll(
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
                              color: Theme.of(context).colorScheme.surface,
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
    ).then((selectedCity) async {
      if (selectedCity != null && widget.usageType == 'landing_page') {
        await CitiesData.storeDefaultCity(selectedCity);
        Get.to(() => const BasePage());
      } else {
        setState(() {
          widget.onValueChanged(selectedCity);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.usageType == 'landing_page') {
      return GestureDetector(
        onTap: () async {
          _searchBottomSheet();
        },
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
            borderRadius: const BorderRadius.all(
              Radius.circular(100.0),
            ),
          ),
          child: Center(
            child: Text(
              'choose city manually',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
          Icons.search_outlined,
        ),
      );
    }
  }
}
