import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int visibleContainerIndex1 = 0;

  void switchContainer1() {
    setState(() {
      visibleContainerIndex1 = (visibleContainerIndex1 + 1) % 4;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff1f262e),
        leading: const Icon(
          Icons.ac_unit,
          color: Color(0xff1f262e),
        ),
        title: Row(
          children: [
            const SizedBox(
              width: 80,
            ),
            const Text(
              "ticketmaster",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Stack(children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                child: Container(
                  color: const Color(0xff1f262e),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                child: myContainer(
                  image: 'assets/images/usa-icon.png',
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                child: myContainer(
                  image: 'assets/images/Ellipse 2.png',
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: visibleContainerIndex1 == 3 ? 1.0 : 0.0,
                child: myContainer(
                  image: 'assets/images/Ellipse 3.png',
                ),
              ),
            ]),
          ],
        ),
        actions: [
          GestureDetector(
             onTap: () {
            switchContainer1();
          },
            child: Stack(children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                   child: myContainer(
                      image: 'assets/images/usa-icon.png',
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                    child: myContainer(
                      image: 'assets/images/usa-icon.png',
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                    child: myContainer(
                      image: 'assets/images/Ellipse 2.png',
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: visibleContainerIndex1 == 3 ? 1.0 : 0.0,
                    child: myContainer(
                      image: 'assets/images/Ellipse 3.png',
                    ),
                  ),
                ]),
          ),
              const SizedBox(width: 15,),
        ],
      ),
      body:  SingleChildScrollView(
       child: Column(
        children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 40,
              color: Colors.black,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text('Atlanta, GA', style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),
            
             Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 40,
              color: Colors.black,
               child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Dates', style: TextStyle(color: Colors.white),),
                    Icon(Icons.keyboard_arrow_right, color: Colors.white,size: 30,)
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
          color: Colors.black,
          child: const Padding(
           padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(color: Colors.grey,),
          )),
        Container(
          color: Colors.black,
          height: 55,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
               width: MediaQuery.of(context).size.width * 0.92,
              height: 40,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Search by Artsist, Event or Venue', style: TextStyle(color: Colors.grey),)),
              ),
            ),
          ),
        ),
          Container(
          color: Colors.black,
          height: 55,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 30,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)
                     ),
                     child: const Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Center(child: Text('Concerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                    ),
                   const  SizedBox(width: 5,),
                     Container(
                      height: 30,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)
                     ),
                     child: const Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Center(child: Text('Sports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                    ),
                     const  SizedBox(width: 5,),
                     Container(
                      height: 30,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)
                     ),
                     child: const Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Center(child: Text('Arts, Theater & Comedy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                    ),
                     const  SizedBox(width: 5,),
                     Container(
                      height: 30,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)
                     ),
                     child: const Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Center(child: Text('Farmily', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                    ),
                     const  SizedBox(width: 5,),
                     Container(
                      height: 30,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white)
                     ),
                     child: const Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Center(child: Text('Carnivals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text('Eaglaes Live at Sphere',  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),), 
                const SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      height: 40,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: Text('Find Tickets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ), 
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              columnContainer(
                context: context,
                color: Colors.deepOrange,
                text: 'Meet Him as a VIP',
                subText: 'Christian Nodal'
              ),
             
              const SizedBox(height: 10,),
              columnContainer(
                context: context,
                color: Colors.black,
                text: 'Roll up in style as a VIP',
                subText: 'Kylie Minogue'
              ),
                 const SizedBox(height: 10,),
              columnContainer(
                context: context,
                color: Colors.blue,
                text: 'Get Falconss ticket in a snap',
                subText: 'NFL Tickets'
              ),
               const SizedBox(height: 10,),
               columnContainer(
                context: context,
                color: Colors.indigo,
                text: 'Get Your Tickets Today',
                subText: 'Cyndi Lauper'
              ),
              const SizedBox(height: 40,),
             const Divider(),
             const SizedBox(height: 10,),
              const Align(
                alignment: Alignment.center,
                child: Text('POPULAR NEAR YOU',style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 10,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Concerts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),),
                      Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 15),), 
                  ],
                ),
                const SizedBox(height: 15,),
                 columnContainer(
                context: context,
                color: Colors.yellow,
                text: 'Pop',
                subText: 'PINK'
              ),
              const SizedBox(height: 20,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Sports', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),),
                      Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 15),), 
                  ],
                ),
                const SizedBox(height: 15,),
                 columnContainer(
                context: context,
                color: Colors.green,
                text: 'NBA',
                subText: 'Atlanta Hawks'
              ),
                const SizedBox(height: 20,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Arts, Theater & Comedy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),),
                      Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 15),), 
                  ],
                ),
                const SizedBox(height: 15,),
                 columnContainer(
                context: context,
                color: Colors.purpleAccent,
                text: 'Comedy',
                subText: 'Katt Williams'
              ),
              const SizedBox(height: 20,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Family', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),),
                      Text('See All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 15),), 
                  ],
                ),
                const SizedBox(height: 15,),
                 columnContainer(
                context: context,
                color: Colors.purple,
                text: 'Childrens Music',
                subText: 'A Charlie Brown Christmas'
              ),

            ],
            
          ),
        )
        ],
       ),
      )
    );
  }

  Column columnContainer({required BuildContext context, color, text, subText}) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height * 0.25,
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: color
                   ),
                ),
                  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),),
                  const SizedBox(height: 7,),
                  Text(subText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                ],
              ),
            ),
              ],
            );
  }
   Container myContainer({
    required String image,
  }) {
    return Container(
      child: Container(
        width: 21,
        height: 21,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}