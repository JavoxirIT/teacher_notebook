import 'dart:async';

import 'package:TeamLead/bloc/student_bloc/student_bloc.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarComponents extends StatefulWidget {
  const SearchBarComponents({super.key});

  @override
  State<SearchBarComponents> createState() => _SearchBarComponentsState();
}

class _SearchBarComponentsState extends State<SearchBarComponents> {
  final _searchText = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchText.text.isNotEmpty) {
        BlocProvider.of<StudentBloc>(context)
            .add(StudentEventSearch(searchText: _searchText.text));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        return Container(
          color: colorWhite,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: TextFormField(
            onChanged: _onSearchChanged,
            controller: _searchText,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  _searchText.clear();
                  BlocProvider.of<StudentBloc>(context).add(StudentEventLoad());
                },
                child: _searchText.text == ""
                    ? const SizedBox()
                    : const Icon(
                        Icons.delete,
                      ),
              ),
              labelText: 'Поиск...',
              border: const UnderlineInputBorder(),
              prefixIcon: const Icon(Icons.youtube_searched_for_outlined),
            ),
          ),
        );
      },
    );
  }
}
