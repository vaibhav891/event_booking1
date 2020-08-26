import 'package:event_booking/screens/bookingpage.dart';
import 'package:event_booking/service/eventservice.dart';
import 'package:flutter/material.dart';

import 'models/event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Event Booking App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                style: TextStyle(),
                decoration: InputDecoration(
                    hintText: 'SEARCH EVENTS', border: OutlineInputBorder()),
              ),
            ),
          ),
          FutureBuilder<List<Event>>(
            future: Events().getEventList(_searchText),
            builder:
                (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.isNotEmpty
                    ? Flexible(
                        child: GridView.builder(
                            //shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: useMobileLayout ? 1 : 2,
                              childAspectRatio: 2,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return eventTile(snapshot.data[index]);
                            }),
                      )
                    : Center(child: Text("No results found!"));
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  Widget eventTile(Event eventItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: InkWell(
        onTap: () => eventItem.seatsAvailable > 0
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingPage(eventId: eventItem.id)))
            : null,
        child: Card(
          child: Column(
            children: [
              Text(
                eventItem.name,
                style: TextStyle(fontSize: 28),
              ),
              Container(
                //width: 300,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          eventItem.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(eventItem.date),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                "Seats Available: ${eventItem.seatsAvailable}"),
                            SizedBox(
                              height: 5,
                            ),
                            eventItem.seatsAvailable > 0
                                ? RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => BookingPage(
                                                  eventId: eventItem.id)));
                                    },
                                    child: const Text("Buy Now"))
                                : Text(
                                    "Sold Out!!",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.red),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
