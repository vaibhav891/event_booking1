import 'package:event_booking/models/event.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final Event event;

  const BookingPage({Key key, this.event}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final formKey = GlobalKey<FormState>();
  int _noOfSeats = 1;
  bool isSuccessful = false;
  String name;
  String email;
  String phone;
  String noOfSeats;
  List<String> otherAttendees = [];

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              widget.event.name,
              style: TextStyle(fontSize: 32),
            ),
          ),
          isSuccessful
              ? Text("Tickets booked!!")
              : Text(
                  "Number of seats available: ${widget.event.seatsAvailable}"),
          Card(
            child: useMobileLayout
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(widget.event.image),
                      )),
                      myForm(),
                    ],
                  )
                : Row(
                    //mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(widget.event.image),
                      )),
                      myForm(),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Widget myForm() {
    return Form(
      key: formKey,
      child: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name: "),
                  SizedBox(
                      width: 200,
                      child: TextFormField(
                        autocorrect: false,
                        validator: (value) {
                          const nameRegex = r"""^[a-zA-Z_]+( [a-zA-Z_]+)*$""";

                          if (value.isEmpty) {
                            return "Please enter your name";
                          } else if (!RegExp(nameRegex).hasMatch(value)) {
                            return "Only letters and spaces are allowed";
                          }
                          name = value;
                        },
                      )),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Email: "),
                  SizedBox(
                      width: 200,
                      child: TextFormField(
                        autocorrect: false,
                        validator: (value) {
                          const emailRegex =
                              r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

                          if (value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(emailRegex).hasMatch(value)) {
                            return "Invalid email";
                          }
                          email = value;
                        },
                      )),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Phone No.: "),
                  SizedBox(width: 200, child: TextFormField()),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Number of Seats: "),
                  SizedBox(
                    width: 100,
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null)
                          return "please enter the no of seats";
                        else if (value > widget.event.seatsAvailable) {
                          return "Number of seats selected is more than available seats";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _noOfSeats = value;
                        });
                        print(value);
                      },
                      items: [
                        DropdownMenuItem(child: Text("1"), value: 1),
                        DropdownMenuItem(child: Text("2"), value: 2),
                        DropdownMenuItem(child: Text("3"), value: 3),
                        DropdownMenuItem(child: Text("4"), value: 4),
                        DropdownMenuItem(child: Text("5"), value: 5),
                        DropdownMenuItem(child: Text("6"), value: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: _noOfSeats > 1
                  ? Column(children: _additionalFormFields())
                  : SizedBox(),
            ),
            Flexible(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: isSuccessful
                      ? null
                      : () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.reset();
                            print("Name: $name");
                            print("Email: $email");
                            print("Phone No.: $phone");
                            print("No of seats: $noOfSeats");
                            print(
                                "Other attendees: ${otherAttendees.toString()}");

                            setState(() {
                              isSuccessful = true;
                            });
                          }
                        },
                  child: Text("Submit"),
                ),
                RaisedButton(
                  onPressed: isSuccessful
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text("Cancel"),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  List<Widget> _additionalFormFields() {
    List<Widget> widgetList = [];
    for (int i = 2; i <= _noOfSeats; i++) {
      var singleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Name of attendee $i: "),
          SizedBox(
              width: 200,
              child: TextFormField(
                autocorrect: false,
                validator: (value) {
                  const emailRegex = r"""^[a-zA-Z_]+( [a-zA-Z_]+)*$""";

                  if (value.isEmpty) {
                    return "Please enter your name";
                  } else if (!RegExp(emailRegex).hasMatch(value)) {
                    return "Only letters and spaces are allowed";
                  }
                  otherAttendees.add(value);
                },
              )),
        ],
      );
      widgetList.add(singleWidget);
    }
    return widgetList;
  }
}
