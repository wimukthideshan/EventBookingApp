import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:eventbookingapp/poviders/event_provider.dart';

class EventSearchBar extends StatefulWidget {
  @override
  _EventSearchBarState createState() => _EventSearchBarState();
}

class _EventSearchBarState extends State<EventSearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        color: Colors.transparent, 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<EventProvider>(
            builder: (context, eventProvider, child) {
              return TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppConstants.primaryColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppConstants.primaryColor),
                  ),
                ),
                onChanged: (value) {
                  eventProvider.searchEvents(value);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
