import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sortviz/SettingsModel.dart';

class SettingsPage extends StatefulWidget {
  static final String route = "/settings";
  final SettingsModel settings;

  SettingsPage({required this.settings});

  @override
  State<StatefulWidget> createState() => _SettingsPageState(settings: settings);
}

class _SettingsPageState extends State {
  SettingsModel settings;
  _SettingsPageState({required this.settings});

  final _key = GlobalKey<FormBuilderState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _key,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'size',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: settings.arraySize.toString(),
                validator: (s) {
                  if (s == null) {
                    return "Size should not be empty.";
                  }

                  try {
                    final i = int.parse(s);
                    if (i <= 0) {
                      return "Size can not be less than or equal to 0.";
                    }
                    return null;
                  } catch (e) {
                    return "Please enter a number.";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Array Size",
                    hintText: "Enter the number of elements to sort"),
              ),
              FormBuilderRadioGroup(
                  name: "array-fill",
                  decoration: InputDecoration(
                    labelText: "Array fill method",
                  ),
                  initialValue: arrayFillMethodToString(settings.fillMethod),
                  options: ["Random", "Sorted - Reverse"]
                      .map((lang) => FormBuilderFieldOption(value: lang))
                      .toList(growable: false),
                  validator: (s) {
                    if (s == null) {
                      return "Select atleast one method";
                    }
                    return null;
                  }),
              FormBuilderTextField(
                name: 'delay',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: settings.milliDelay.toString(),
                validator: (s) {
                  if (s == null) {
                    return "Delay should not be empty.";
                  }

                  try {
                    final i = int.parse(s);
                    if (i <= 0) {
                      return "Delay can not be less than or equal to 0.";
                    }
                  } catch (e) {
                    return "Please enter a number.";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Delay duration",
                    hintText:
                        "Enter the number of milliseconds to wait b.w operations"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      return;
                    }

                    _key.currentState!.save();

                    settings.arraySize =
                        int.parse(_key.currentState!.fields["size"]?.value);

                    settings.milliDelay =
                        int.parse(_key.currentState!.fields["delay"]?.value);

                    final fill = _key.currentState!.fields["array-fill"]?.value;
                    settings.fillMethod = stringToArrayFillMethod(fill)!;

                    Navigator.pop(context, settings);
                  },
                  child: Text("Apply"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
