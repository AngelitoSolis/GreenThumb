class Plant {
  final int plantId;

  final String size;

  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;

  final String decription;

  Plant({
    required this.plantId,
    required this.category,
    required this.plantName,
    required this.size,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.decription,
  });

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
      plantId: 0,
      category: 'Indoor',
      plantName: 'Aloe Vera',
      size: 'Small',
      humidity: 40,
      temperature: '55 - 85',
      imageURL: 'assets/images/aloev.png',
      decription:
          'Aloe is a cactus-like plant that grows in hot, dry climates. It is cultivated in subtropical regions around the world, including the southern border areas of Texas, New Mexico, Arizona, and California.',
    ),
    Plant(
      plantId: 1,
      category: 'Outdoor',
      plantName: 'Philodendron',
      size: 'Medium',
      humidity: 56,
      temperature: '19 - 22',
      imageURL: 'assets/images/plant-two.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
    Plant(
      plantId: 2,
      category: 'Indoor',
      plantName: 'Beach Daisy',
      size: 'Large',
      humidity: 34,
      temperature: '22 - 25',
      imageURL: 'assets/images/plant-three.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
    Plant(
      plantId: 3,
      category: 'Outdoor',
      plantName: 'Big Bluestem',
      size: 'Small',
      humidity: 35,
      temperature: '23 - 28',
      imageURL: 'assets/images/plant-one.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
    Plant(
      plantId: 4,
      category: 'Recommended',
      plantName: 'Big Bluestem',
      size: 'Large',
      humidity: 66,
      temperature: '12 - 16',
      imageURL: 'assets/images/plant-four.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
    Plant(
      plantId: 5,
      category: 'Outdoor',
      plantName: 'Meadow Sage',
      size: 'Medium',
      humidity: 36,
      temperature: '15 - 18',
      imageURL: 'assets/images/plant-five.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
    Plant(
      plantId: 6,
      category: 'Garden',
      plantName: 'Plumbago',
      size: 'Small',
      humidity: 46,
      temperature: '23 - 26',
      imageURL: 'assets/images/plant-six.png',
      decription:
          'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
          'even the harshest weather condition.',
    ),
  ];
}
