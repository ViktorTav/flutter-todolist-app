import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget/config.dart';
import 'package:widget/src/models/notification_action.dart';
import 'package:widget/src/models/scheduled_notification.dart';
import 'package:widget/src/models/todo_item.dart';
import 'package:widget/src/models/todo_list.dart';
import 'package:widget/src/services/notification.dart';
import 'package:widget/src/views/widgets/form/date_picker.dart';
import 'package:widget/src/views/widgets/form/dropdown.dart';
import 'package:widget/src/views/widgets/form/input.dart';
import 'package:widget/src/views/widgets/form/text_area.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleInputController = TextEditingController();
  final _contentInputController = TextEditingController();
  final _datePickerInputController = TextEditingController();

  final _notificationTimeDropdownKey = GlobalKey<FormDropdownState>();

  DateTime? _taskDate, _scheduledNotificationTime;

  void _handleSubmit(BuildContext context) {
    final notificationService =
        Provider.of<NotificationService>(context, listen: false);

    if (!_formKey.currentState!.validate()) return;

    final TodoItem todoItem = TodoItem.create(
        title: _titleInputController.text,
        content: _contentInputController.text,
        taskDate: _taskDate!,
        scheduledNotificationTime:
            DateTime.now().add(const Duration(seconds: 5)));

    if (todoItem.scheduledNotificationTime != null) {
      final scheduledNotification = ScheduledNotification(
          title: "Entrega de tarefa",
          content: todoItem.title,
          payload: {"taskId": todoItem.id},
          date: todoItem.scheduledNotificationTime!,
          actions: Config.notification["task"]!["actions"]
              as List<NotificationAction>);

      todoItem.scheduledNotificationId = scheduledNotification.id;

      notificationService.scheduleNotification(scheduledNotification);
    }

    Provider.of<TodoList>(context, listen: false).addItem(todoItem: todoItem);

    Navigator.pop(context);
  }

  void handleDateChange(DateTime? value) {
    setState(() {
      _taskDate = value;
    });
  }

  @override
  void dispose() {
    final inputControllers = <TextEditingController>[
      _titleInputController,
      _contentInputController,
      _datePickerInputController,
    ];

    for (var controller in inputControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  List<DropdownMenuItem<Duration>> _buildNotificationTimesDropdownMenuItems() {
    const dropdownItems = <List<dynamic>>[
      ["Sem notificação", Duration(minutes: 0)],
      ["5 minutos", Duration(minutes: 5)],
      ["30 minutos", Duration(minutes: 30)],
      ["1 hora", Duration(hours: 1)],
      ["2 horas", Duration(hours: 2)],
      ["12 horas", Duration(hours: 12)],
      ["Dia anterior", Duration(days: 1)]
    ];

    final list = <DropdownMenuItem<Duration>>[];

    for (var dropdownItem in dropdownItems) {
      list.add(DropdownMenuItem(
          value: dropdownItem[1], child: Text(dropdownItem[0])));
    }

    return list;
  }

  String? _validateNotificationTime(Duration? value) {
    if (_taskDate == null) return null;

    final Duration notificationTime = value!;

    if (notificationTime.inMinutes == 0) {
      _scheduledNotificationTime = null;
      return null;
    }

    final DateTime scheduledNotificationTime =
        _taskDate!.subtract(notificationTime);

    /*
      Verificamos se o horário da notificação agendanda não é anterior que o horário atual.  
    */

    if (scheduledNotificationTime.isBefore(DateTime.now())) {
      return "Não é possível criar uma notificação para uma data menor do que a atual. Escolha outro horário para a notificação.";
    }

    _scheduledNotificationTime = scheduledNotificationTime;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          FormInput(
            controller: _titleInputController,
            fieldName: "Título",
            labelText: "Título:",
            autoFocus: true,
            required: true,
          ),
          FormTextArea(
            controller: _contentInputController,
            fieldName: "Conteúdo",
            labelText: "Conteúdo:",
          ),
          FormDatePicker(
            controller: _datePickerInputController,
            fieldName: "Data de entrega",
            labelText: "Data de entrega:",
            onChanged: handleDateChange,
          ),
          FormDropdown<Duration>(
              enabled: _taskDate != null,
              key: _notificationTimeDropdownKey,
              validator: _validateNotificationTime,
              labelText: "Notificação:",
              items: _buildNotificationTimesDropdownMenuItems(),
              initialValueIndex: 0),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0)),
              onPressed: () => _handleSubmit(context),
              child: const Text("Criar"))
        ],
      ),
    );
  }
}
