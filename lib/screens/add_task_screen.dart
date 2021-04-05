import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listac/helpers/database_helper.dart';
import 'package:listac/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {

  final Function updateTaskList;
  final Task task;

  AddTaskScreen({this.updateTaskList, this.task});

  @override
  _StateAdd createState() => _StateAdd();
}

class _StateAdd extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String _title = '';
  String _priority;
  DateTime _tgl = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _prioritys = ['Low', 'Medium', 'Height'];

  @override
  void initState() {
    super.initState();

    if(widget.task != null) {
      _title = widget.task.title;
      _tgl = widget.task.tgl;
      _priority = widget.task.priority;
    }

    _dateController.text = _dateFormatter.format(_tgl);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handlerdate() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _tgl,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (date != null && date != _tgl) {
      setState(() {
        _tgl = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      print('$_title, $_tgl, $_priority');

      Task task = Task(title: _title, tgl: _tgl, priority: _priority);

      if(widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      }else{
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
    }
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text(
                  'Add Activity',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Judul Kegiatan',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => _title = input.trim().isEmpty
                            ? 'mohon isi judul list'
                            : null,
                        onSaved: (input) => _title = input,
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: TextFormField(
                        controller: _dateController,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        onTap: _handlerdate,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Pelaksanaan',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _prioritys.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Kepentingan',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => _priority == null
                            ? 'mohon isi level kepentingan'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: FlatButton(
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
