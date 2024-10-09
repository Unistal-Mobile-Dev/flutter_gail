import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class SearchTextField extends StatelessWidget {
  final void Function(dynamic) onChange;
  final void Function(dynamic) onClick;
  final List<dynamic> list;
  final String label;
  final double? height;
  final TextEditingController? controller;
  final int? maxLines;
  final bool? isLoader;

  const SearchTextField(
      {super.key,
      required this.onChange,
      required this.onClick,
      required this.label,
      this.height,
      this.maxLines,
      this.isLoader,
      required this.list,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return _searchTextField(searchController: controller, context: context);
  }

  Widget _searchTextField(
      {TextEditingController? searchController,
      required BuildContext context}) {
    return Column(
      children: [
        TextFieldWidget(
            labelText: label,
            isRequired: true,
            controller: controller,
            onChanged: (keyWord) {
              onChange.call(keyWord);
            }),
        isLoader == true
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: const DottedLoaderWidget(),
              )
            : _list(list: list, context: context),
      ],
    );
  }

  Widget _list({required dynamic list, required BuildContext context}) {
    return list.isNotEmpty
        ? SizedBox(
            height: list.length == 1
                ? MediaQuery.of(context).size.height * 0.07
                : list.length == 2
                    ? MediaQuery.of(context).size.height * 0.12
                    : list.length == 3
                        ? MediaQuery.of(context).size.height * 0.19
                        : list.length == 4
                            ? MediaQuery.of(context).size.height * 0.16
                            : MediaQuery.of(context).size.height / 3,
            child: Card(
              child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: InkWell(
                        onTap: () {
                          onClick.call(list[index]);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${list[index].pipeNumber}|${list[index].heatNumber}|${list[index].pipeLength}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            ),
                            list.length - 1 != index
                                ? const Divider()
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        : const SizedBox.shrink();
  }
}
