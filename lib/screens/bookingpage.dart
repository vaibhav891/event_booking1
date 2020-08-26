import 'package:event_booking/bloc/tktbooking_bloc.dart';
import 'package:event_booking/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPage extends StatefulWidget {
  final String eventId;

  const BookingPage({Key key, this.eventId}) : super(key: key);

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
  //String noOfSeats;
  List<String> otherAttendees = [];

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return BlocProvider(
      create: (context) =>
          TktbookingBloc()..add(TktbookingInitEvent(widget.eventId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Booking Page"),
        ),
        body: BlocBuilder<TktbookingBloc, TktbookingState>(
          builder: (context, state) => state is TktbookingEventLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        state is TktbookingEventLoaded ? state.event.name : "",
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                    state.isComplete
                        ? Text("Tickets booked!!")
                        : Text(
                            "Number of seats available: ${state.event.seatsAvailable}"),
                    Card(
                      child: useMobileLayout
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(state.event.image),
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
                                  child: Image.asset(state.event.image),
                                )),
                                myForm(),
                              ],
                            ),
                    )
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget myForm() {
    return BlocBuilder<TktbookingBloc, TktbookingState>(
      builder: (context, state) => state is TktbookingEventLoaded
          ? Form(
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
                                  const nameRegex =
                                      r"""^[a-zA-Z_]+( [a-zA-Z_]+)*$""";

                                  if (value.isEmpty) {
                                    return "Please enter your name";
                                  } else if (!RegExp(nameRegex)
                                      .hasMatch(value)) {
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
                                  } else if (!RegExp(emailRegex)
                                      .hasMatch(value)) {
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
                                else if (value > state.event.seatsAvailable) {
                                  return "Number of seats selected is more than available seats";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _noOfSeats = value;
                                });
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
                          onPressed: state.isComplete
                              ? null
                              : () {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.reset();
                                    print("Name: $name");
                                    print("Email: $email");
                                    print("Phone No.: $phone");
                                    print("No of seats: $_noOfSeats");
                                    print(
                                        "Other attendees: ${otherAttendees.toString()}");

                                    // setState(() {
                                    //   isSuccessful = true;
                                    // });
                                    BlocProvider.of<TktbookingBloc>(context)
                                        .add(BookingSubmitted(
                                            _noOfSeats, widget.eventId));
                                  }
                                },
                          child: Text("Submit"),
                        ),
                        RaisedButton(
                          onPressed: state.isComplete
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
            )
          : CircularProgressIndicator(),
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
