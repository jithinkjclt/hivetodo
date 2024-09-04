import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const DateTimePicker({Key? key, required this.onDateTimeSelected})
      : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(
            selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text(
            selectedTime == null
                ? 'Select Time'
                : 'Selected Time: ${selectedTime!.format(context)}',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedDate != null && selectedTime != null
              ? () {
                  final DateTime finalDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  widget.onDateTimeSelected(finalDateTime);
                }
              : null,
          child: Text('Confirm DateTime'),
        ),
      ],
    );
  }
}
