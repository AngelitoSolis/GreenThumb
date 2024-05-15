import 'package:flutter/material.dart';

class PlantTips extends StatelessWidget {
  const PlantTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Tips'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              'General Plant Care Tips',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              '1. Water your plants regularly, but do not overwater. Check the soil moisture before watering.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. Ensure your plants receive adequate sunlight. Some plants need direct sunlight, while others thrive in indirect light.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '3. Use the right type of soil for your plants. Different plants require different soil types for optimal growth.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '4. Fertilize your plants to provide them with necessary nutrients. Follow the recommended guidelines for each plant type.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '5. Prune your plants to remove dead or yellowing leaves and to encourage new growth.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '6. Be mindful of pests and diseases. Regularly inspect your plants and take appropriate measures if needed.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '7. Repot your plants when they outgrow their current containers to ensure they have enough space to grow.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
