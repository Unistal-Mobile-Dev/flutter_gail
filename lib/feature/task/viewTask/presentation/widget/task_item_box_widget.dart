import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

class TaskItemBoxWidget extends StatelessWidget {
  final TaskModel taskData;
  const TaskItemBoxWidget({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.themeColor,
      child: Padding(padding: const EdgeInsets.all(0.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
             width: MediaQuery.of(context).size.width,
             padding: const EdgeInsets.all(8.0),
             decoration: BoxDecoration(
               borderRadius: const BorderRadius.only(
                   topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
               color: AppColor.lightGrey,
             ),
              child: TextWidget(taskData.taskId.toString(),
                fontWeight: FontWeight.w700,
                fontSize: AppFont.font_12,
                color: AppColor.themeColor,),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.region + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.region.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.maintenanceBase + " : ",
                  fontSize: AppFont.font_11,
                  fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.maintenanceBase.toString(),
                   fontSize: AppFont.font_11,
                   )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.pipelineName + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.pipeline.toString(),
                   fontSize: AppFont.font_11,
                 )
                )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.sectionName + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.section.toString(),
                   fontSize: AppFont.font_11,
                  )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.patrolRouteName + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.patrollRouteName.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),
           
           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.patrolRouteLength + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.patrollRouteLength.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.assignedDate + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.assignedDate.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.patrollingStartDate + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.assignedStartDate.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.patrollingEndDate + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.assignedEndDate.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.shiftName + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.shiftName.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.repeatFrequency + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(taskData.repeatFrequency.toString(),
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           Padding(
             padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
             child: Row(
               children: [
                 TextWidget(AppString.taskStatus + " : ",
                   fontSize: AppFont.font_11,
                   fontWeight: FontWeight.w700,
                 ),
                 Expanded(child: TextWidget(
                   taskData.patrollManStatus.toString() == "0" ? "Not Started"
                      :  taskData.patrollManStatus.toString() == "1" ? "Started"
                       : taskData.patrollManStatus.toString() == "2" ? "Pause" : "Completed",
                   fontSize: AppFont.font_11,
                 )
                 )
               ],
             ),
           ),

           SizedBox(
             height: MediaQuery.of(context).size.width * 0.02,
           ),
         ],
       ),
      ),
    );
  }
}
