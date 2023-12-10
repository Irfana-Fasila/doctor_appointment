import 'package:DocTime/firestore_data/search_list.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  final TextEditingController _textController = TextEditingController();
  late String search;
  late var _length = 0;

  @override
  void initState() {
    super.initState();
    search = _textController.text;
    _length = search.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Find Doctors'),
        actions: <Widget>[
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                textCapitalization: TextCapitalization.none,
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Search Doctor',
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  prefixStyle: TextStyle(
                    color: Colors.black54,
                  ),
                  suffixIcon: _textController.text.isNotEmpty
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              _length = search.length;
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                          ),
                        )
                      : const SizedBox(),
                ),
                // onFieldSubmitted: (String _searchKey) {
                //   setState(
                //     () {
                //       print('>>>' + _searchKey);
                //       search = _searchKey;
                //     },
                //   );
                // },
                onChanged: (String searchKey) {
                  setState(
                    () {
                      print('>>>$searchKey');
                      search = searchKey;
                      _length = search.length;
                    },
                  );
                },
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction: TextInputAction.search,
                autofocus: false,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: _length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          print(_length);
                          _length = 1;
                        });
                      },
                      child: const Text(
                        'Show All',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const Image(image: AssetImage('assets/search-bg.png')),
                  ],
                ),
              )
            : SearchList(
                searchKey: search,
              ),
      ),
    );
  }
}
