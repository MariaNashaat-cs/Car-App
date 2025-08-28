import 'package:flutter/material.dart';
import 'rent.dart';

void main() {
  runApp(const CarSalesApp());
}

class CarSalesApp extends StatelessWidget {
  const CarSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuxHunt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const CarListingScreen(),
    );
  }
}

class CarModel {
  final String name;
  final String year;
  final String price;
  final String image;
  final String engine;
  final String horsepower;
  final String mileage;
  final String location;
  final String seller;
  final int priceValue;

  CarModel({
    required this.name,
    required this.year,
    required this.price,
    required this.image,
    required this.engine,
    required this.horsepower,
    required this.mileage,
    required this.location,
    required this.seller,
    required this.priceValue,
  });
}

class CarListingScreen extends StatefulWidget {
  const CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  String searchQuery = '';
  RangeValues priceRange = const RangeValues(0, 3000000);
  bool isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Luxury Ride', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              onSearchChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              onFilterTap: () {
                setState(() {
                  isFilterVisible = !isFilterVisible;
                });
              },
            ),
          ),
          if (isFilterVisible)
            PriceFilterWidget(
              priceRange: priceRange,
              onPriceRangeChanged: (range) {
                setState(() {
                  priceRange = range;
                });
              },
            ),
          Expanded(
            child: CarListView(
              searchQuery: searchQuery,
              priceRange: priceRange,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;

  const SearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'What are you looking for?',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: widget.onSearchChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              widget.onSearchChanged(_searchController.text);
            },
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: widget.onFilterTap,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceFilterWidget extends StatefulWidget {
  final RangeValues priceRange;
  final Function(RangeValues) onPriceRangeChanged;

  const PriceFilterWidget({
    super.key,
    required this.priceRange,
    required this.onPriceRangeChanged,
  });

  @override
  State<PriceFilterWidget> createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentRange.start.toInt()} L.E',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '${_currentRange.end.toInt()} L.E',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          RangeSlider(
            values: _currentRange,
            min: 0,
            max: 3000000,
            divisions: 30,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              '${_currentRange.start.toInt()} L.E',
              '${_currentRange.end.toInt()} L.E',
            ),
            onChanged: (values) {
              setState(() {
                _currentRange = values;
              });
            },
            onChangeEnd: (values) {
              widget.onPriceRangeChanged(values);
            },
          ),
        ],
      ),
    );
  }
}

class CarListView extends StatelessWidget {
  final String searchQuery;
  final RangeValues priceRange;

  final List<CarModel> cars = [
    CarModel(
      name: 'Mercedes-Benz G-Class (G 550)',
      year: '2025',
      price: 'Starting at 1400000 L.E',
      image: 'images/images/gclass.jpeg',
      engine: '3.0L inline-6 turbo with mild hybrid assist (G 550)',
      horsepower: '443 bhp',
      mileage: '25.26 kmpl',
      location: 'Pedal Road',
      seller: 'Mercedes',
      priceValue: 1400000,
    ),
    CarModel(
      name: 'Alfa Romeo Giulia',
      year: '2025',
      price: 'Starting at 3000000 L.E',
      image: 'images/images/alfaromeo.jpeg',
      engine: '1000 cc',
      horsepower: '505 bhp',
      mileage: '25.26 kmpl',
      location: 'Pedal Road',
      seller: 'Alfa Romeo',
      priceValue: 3000000,
    ),
    CarModel(
      name: 'Aston Martin AMV Vantage',
      year: '2022',
      price: '1420000 L.E',
      image: 'images/images/aston martin.jpeg',
      engine: '4.0L twin-turbo V8',
      horsepower: '503 bhp',
      mileage: '7.7 kmpl',
      location: 'Pedal Road',
      seller: 'Aston Martin',
      priceValue: 1420000,
    ),
    CarModel(
      name: 'Porsche Panamera',
      year: '2022',
      price: '1800000 L.E',
      image: 'images/images/porche.jpeg',
      engine: '2.9L',
      horsepower: '620 bhp',
      mileage: '10.2 kmpl',
      location: 'Pedal Road',
      seller: 'Porsche',
      priceValue: 1800000,
    ),
  ];

  CarListView({
    super.key,
    required this.searchQuery,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    List<CarModel> filteredCars = cars.where((car) {
      bool matchesSearch = searchQuery.isEmpty ||
          car.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          car.seller.toLowerCase().contains(searchQuery.toLowerCase()) ||
          car.year.toLowerCase().contains(searchQuery.toLowerCase()) ||
          car.engine.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesPrice =
          car.priceValue >= priceRange.start && car.priceValue <= priceRange.end;

      return matchesSearch && matchesPrice;
    }).toList();

    if (filteredCars.isEmpty) {
      return const Center(
        child: Text(
          'No cars match your search criteria',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        return CarListItem(car: filteredCars[index]);
      },
    );
  }
}

class CarListItem extends StatelessWidget {
  final CarModel car;

  const CarListItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailsPage(carModel: car),
                    ),
                  );
                },
                child: Image.asset(
                  car.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.directions_car,
                            size: 80, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            car.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${car.name} ${car.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.settings,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              car.engine,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.speed, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              car.horsepower,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.local_gas_station,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              car.mileage,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        car.seller,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              car.location,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}