import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class DataTableWidget<T> extends StatefulWidget {
  final T fixedCornerCell;
  final List<T> fixedColCells;
  final List<T> fixedRowCells;
  final List<List<T>> rowsCells;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;
  final Color borderColor;

  const DataTableWidget({
    super.key,
    required this.fixedCornerCell,
    required this.fixedColCells,
    required this.fixedRowCells,
    required this.rowsCells,
    this.fixedColWidth = 60.0,
    this.cellHeight = 56.0,
    this.cellWidth = 120.0,
    this.cellMargin = 10.0,
    this.cellSpacing = 10.0,
    required this.borderColor,
  });

  @override
  State<StatefulWidget> createState() => DataTableWidgetState();
}

class DataTableWidgetState<T> extends State<DataTableWidget<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  Widget _buildChild(double width, T data) => SizedBox(
    width: width,
    child: TextWidget(
      '$data',
      fontSize: AppFont.font_11,
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildHeaderChild(double width, T data) => SizedBox(
    width: width,
    child: TextWidget(
      '$data',
      fontSize: AppFont.font_12,
      fontWeight: FontWeight.w700,
      color: EnvironmentConfig.of(context)!.primaryTheme,
      textAlign: TextAlign.center,
    ),
  );

  TableBorder _buildHeaderBorder({bool bottom = true,}) {
    return  TableBorder(
      top: const BorderSide(color: Colors.black),
      left: const BorderSide(color: Colors.black),
      right: const BorderSide(color: Colors.black),
      bottom: bottom ? const BorderSide(color: Colors.black) : BorderSide.none,
      verticalInside: const BorderSide(color: Colors.black),
    );
  }

  TableBorder _buildBorder({
    bool top = false,
    bool left = false,
    bool right = false,
    bool bottom = false,
    bool verticalInside = false,
  }) {
    return TableBorder(
      top: top  ? BorderSide(color: widget.borderColor) : BorderSide.none,
      left: left ? BorderSide(color: widget.borderColor) : BorderSide.none,
      right: right ? BorderSide(color: widget.borderColor) : BorderSide.none,
      bottom: bottom ? BorderSide(color: widget.borderColor) : BorderSide.none,
      verticalInside: verticalInside
          ? BorderSide(color: widget.borderColor)
          : BorderSide.none,
    );
  }

  Widget _buildFixedCol() => DataTable(
      border: _buildBorder(right: true),
      horizontalMargin: widget.cellMargin,
      columnSpacing: widget.cellSpacing,
      headingRowHeight: widget.cellHeight,
      dataRowHeight: widget.cellHeight,
      columns: [
        DataColumn(
            label:
            _buildChild(widget.fixedColWidth, widget.fixedColCells.first))
      ],
      rows: widget.fixedColCells
          .map((c) =>
          DataRow(cells: [DataCell(_buildChild(widget.fixedColWidth, c))]))
          .toList());

  Widget _buildFixedRow() => Material(
    color: Colors.white,
    child: DataTable(
      border: _buildHeaderBorder(bottom: false),
      horizontalMargin: widget.cellMargin,
      columnSpacing: widget.cellSpacing,
      headingRowHeight: widget.cellHeight,
      dataRowHeight: widget.cellHeight,
      columns: widget.fixedRowCells
          .map(
            (c) => DataColumn(
          label: _buildHeaderChild(widget.cellWidth, c),
        ),
      ).toList(),
      rows: const [],
    ),
  );

  Widget _buildSubTable() {
    List<DataRow> rows = [];
    for(int i = 0;  i < widget.rowsCells.length; i++){
       if(i != 0){
        rows.add(DataRow(
                   cells: widget.rowsCells[i]
                       .map((c) => DataCell(_buildChild(widget.cellWidth, c)))
                       .toList()));
       }
    }
    return Material(
        color: Colors.white,
        child: DataTable(
            border: _buildHeaderBorder(),
            horizontalMargin: widget.cellMargin,
            columnSpacing: widget.cellSpacing,
            headingRowHeight: widget.cellHeight,
            dataRowHeight: widget.cellHeight,
            columns: widget.rowsCells.first
                .map((c) => DataColumn(label: _buildChild(widget.cellWidth, c)))
                .toList(),
            rows: rows
        )
    );
  }

  Widget _buildCornerCell() => DataTable(
    border: _buildBorder(bottom: true, right: true),
    horizontalMargin: widget.cellMargin,
    columnSpacing: widget.cellSpacing,
    headingRowHeight: widget.cellHeight,
    dataRowHeight: widget.cellHeight,
    columns: [
      DataColumn(
        label: _buildChild(
          widget.fixedColWidth,
          widget.fixedCornerCell,
        ),
      )
    ],
    rows: const [],
  );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: _rowController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: _buildFixedRow(),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: _subTableXController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: _subTableYController,
              scrollDirection: Axis.vertical,
              child: _buildSubTable(),
            ),
          ),
        ),
      ],
    );
  }
}