import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../poviders/event_provider.dart';

class FilterBar extends StatefulWidget {
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;
  bool _filtersApplied = false;

  String? _selectedLocation;
  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _applyFilters(EventProvider eventProvider) {
    eventProvider.applyFilters(_selectedLocation, _selectedCategory, _selectedDate);
    setState(() {
      _filtersApplied = true;
      _isExpanded = false;
    });
    _controller.reverse();
  }

  void _clearFilters(EventProvider eventProvider) {
    eventProvider.clearFilters();
    setState(() {
      _selectedLocation = null;
      _selectedCategory = null;
      _selectedDate = null;
      _filtersApplied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: _toggleExpanded,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isExpanded ? AppConstants.primaryColor : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppConstants.primaryColor),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_list,
                  color: _isExpanded ? Colors.white : AppConstants.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Filters',
                  style: TextStyle(
                    color: _isExpanded ? Colors.white : AppConstants.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: _isExpanded ? Colors.white : AppConstants.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller.view,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          _buildDropdown(
                            'Location',
                            eventProvider.locations,
                            _selectedLocation,
                            (String? value) {
                              setState(() => _selectedLocation = value);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildDropdown(
                            'Category',
                            eventProvider.categories,
                            _selectedCategory,
                            (String? value) {
                              setState(() => _selectedCategory = value);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildDatePicker(context),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _applyFilters(eventProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (_filtersApplied)
          Padding(
            padding: EdgeInsets.only(right: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _clearFilters(eventProvider),
                child: Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: AppConstants.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Removed the black border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppConstants.secondaryColor,
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dropdownColor: Colors.white,
    icon: Icon(
      Icons.arrow_drop_down,
      color: AppConstants.primaryColor,
    ),
    style: TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    value: selectedValue,
    items: items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }).toList(),
    onChanged: onChanged,
  );
}



  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}