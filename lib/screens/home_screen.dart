import 'package:eventbookingapp/poviders/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/event_list_item.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_bar.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<EventProvider>().fetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EventSearchBar(),
            FilterBar(),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  if (eventProvider.events.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: eventProvider.events.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: eventProvider.events[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}