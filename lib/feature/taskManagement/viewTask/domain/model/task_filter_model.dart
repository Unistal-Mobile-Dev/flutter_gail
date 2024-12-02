class TaskFilterModel {

  dynamic status;
  String? name;
  bool? isSelected;

  TaskFilterModel({
    this.name,
    this.status,
    this.isSelected,
  });

  getData() {

    List<TaskFilterModel> list = [];
    list.add(
      TaskFilterModel(
        status: "",
        name: "All",
        isSelected: true,
      )
    );
    list.add(
        TaskFilterModel(
            status: "0",
            name: "Pending",
          isSelected: false,
        )
    );
    list.add(
        TaskFilterModel(
            status: "1",
            name: "Ongoing",
            isSelected: false,
        )
    );
    list.add(
        TaskFilterModel(
            status: "2",
            name: "Hold",
            isSelected: false,
        )
    );
    list.add(
        TaskFilterModel(
            status: "3",
            name: "Complete",
          isSelected: false,
        )
    );
    return list;
  }

}