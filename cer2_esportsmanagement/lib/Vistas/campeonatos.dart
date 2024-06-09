
import 'package:flutter/material.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class VistaCampeonatos extends StatelessWidget {
  const VistaCampeonatos({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ["VALORANT", "FIFA", "Rocket League"];
    
    final List<Widget> images = [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/valorant.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/FIFA.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rocket.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appba.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppBar(
              title: Text('EQUIPOS'),
              titleTextStyle: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                letterSpacing: 4,
              ),
              
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wall.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
      Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: VerticalCardPager(
                  titles: titles, 
                  images: images, 
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold), 
                  onPageChanged: (page) {
                    // a
                  },
                  onSelectedItem: (index) {
                    
                  },
          
                  initialPage: 1, 
                  align: ALIGN.LEFT, 
                  physics: ClampingScrollPhysics() 
                  ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }
}
