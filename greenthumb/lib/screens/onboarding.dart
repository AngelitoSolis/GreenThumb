import 'package:flutter/material.dart';
import 'package:greenthumb/screens/login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> _imagePaths = [
    'lib/images/logo.png',
    'assets/images/plant-four.png',
    'assets/images/plant-six.png',
  ];

  final List<String> _titles = [
    'Welcome to GreenThumb',
    'Explore Plants',
    'Find Inspiration',
  ];

  final List<String> _descriptions = [
    'Discover a world of plants and enhance your indoor and outdoor space.',
    'Browse through a wide variety of plants and find the perfect fit for your home.',
    'Get inspired with beautiful plant images and care tips.',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => Login()));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _titles.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                imagePath: _imagePaths[index],
                title: _titles[index],
                description: _descriptions[index],
              );
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _titles.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 300.0,
        ),
        SizedBox(height: 30.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
