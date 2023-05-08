import 'package:flutter/material.dart';

import '../ui/input_decorations.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> list;
  final String label;
  const CustomDropDown({super.key, required this.list, required this.label});

  @override
  State<CustomDropDown> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {

  String dropdownValue = widget.list.first;

    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        focusColor: const Color.fromARGB(255, 111, 111, 252),
        decoration: InputDecorations.authImputDecoration(hintText: '', labelText: widget.label, context: context),
        value: dropdownValue,
        elevation: 16,
        style: const TextStyle(color: Color.fromARGB(255, 111, 111, 252),),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });

          // TODO: Poner que si es matricula guarde la matricula en las preferencias y si no se guarde el nombre del conductor en las preferencias.
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}