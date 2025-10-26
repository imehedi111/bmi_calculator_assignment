import 'package:flutter/material.dart';

//here we define data type for weight calculate unit.....kg and lbs...//
enum WeightType { kg, lbs }

//here we define data type we need or calculate BMI.......data type..//
enum HeightType { cm, feetInch }

class BmiHome extends StatefulWidget {
  const BmiHome({super.key});

  @override
  State<BmiHome> createState() => _BmiHomeState();
}

class _BmiHomeState extends State<BmiHome> {
  //weight er variable neoar jonno weightType declare korlam....//
  WeightType weightType = WeightType.kg;

  //height er variable neoar jonno heightType declare korlam....//
  HeightType heightType = HeightType.cm;

  //text filed er jonno controller neoa holo....controller..//
  final TextEditingController weightKGController = TextEditingController();
  final TextEditingController weightLbsController = TextEditingController();
  final TextEditingController heightCMController = TextEditingController();
  final TextEditingController heightFeetController = TextEditingController();
  final TextEditingController heightInchController = TextEditingController();

  String? bmiresult;

  //lbs to kg convert.............lbs to kg...//
  double? lbsToKgCal() {
    final weightLbs = double.tryParse(weightLbsController.text.trim());
    //here we getting height units calculation..........................//height unit..//
    final m = heightType == HeightType.cm ? cmToM() : feetInchToM();

    if (m == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    }
    //condition checking for weightLbs input...............//
    if (weightLbs == null || weightLbs <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Pound Value')));
    } else {
      //here we convert lbs value to kg............///lbs to kg//
      //we know 1 pound = 0.45359237 KG...........//
      final lastKg = weightLbs * 0.45359237;
      return lastKg / (m*m);
    }
    return null;
  }

  //kg calculation here.............kg calculate...//
  double? kgCal() {
    final weightKg = double.tryParse(weightKGController.text.trim());
    //here we getting height units calculation..........................//height unit..//
    final m = heightType == HeightType.cm ? cmToM() : feetInchToM();

    if (m == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    }
    //condition checking for weightLbs input...............//
    if (weightKg == null || weightKg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid KG Value')));
    } else {
      return weightKg / (m*m);
    }
    return null;
  }

  //create methode to convert cm to miter, feet/inch to meter.................converting...//
  //1 m = 100 cm then - height value need to devided by 100....//
  double? cmToM() {
    final cm = double.tryParse(heightCMController.text.trim());

    if (cm == null || cm <= 0) return null;

    return cm / 100.0;
  }

  //create method for feet to meter convert...........//feet to meter//
  //1 inch = 0.0254 m....................//
  double? feetInchToM() {
    final feet = double.tryParse(heightFeetController.text.trim());
    final inch = double.tryParse(heightInchController.text.trim());

    if (feet == null || feet <= 0 || inch == null || inch < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Input')));
      return null;
    }
    if (inch > 12) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Inch can\'t be over 12')));
      return null;
    } else if (inch == 12) {
      feet + 1;
    }

    final totalInch = feet * 12 + inch;

    if (totalInch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return null;
    } else {
      return totalInch * 0.0254;
    }
  }

  //method for bmi weight chart categories.............//
  String? category;
  String categoryResult(double bmi) {
    if (bmi < 18.5) return "Under Weight";
    if (bmi <= 24.9) return "Normal";
    if (bmi <= 29.9) return "Overweight";
    return "Obese";
  }

  //methode for colors depends on category.....///
  Color bmiColor(double bmi){
    if (bmi == 0) return Colors.grey; //default
    if (bmi < 18.5) return Colors.blue;
    if (bmi <= 24.9) return Colors.green;
    if (bmi <= 29.9) return Colors.orange;
    return Colors.red;
  }

  //get images based no bmi result.....//
  Image bmiImage(double bmi){
    if (bmi == 0) return Image(image: AssetImage('asset/none.jpg'),width: 240,);
    if (bmi < 18.5) return Image(image: AssetImage('asset/underweight.jpeg'),width: 240,);
    if (bmi <= 24.9) return Image(image: AssetImage('asset/normal.jpg'),width: 240,);
    if (bmi <= 29.9) return Image(image: AssetImage('asset/overweight.jpg'),width: 240,);
    return Image(image: AssetImage('asset/obese.png'),width: 240,);
  }

  //method for calculation of input data units................//
  void _calculator() {

    final bmi = weightType == WeightType.kg ? kgCal() : lbsToKgCal();
    final cat = categoryResult(bmi!);
    setState(() {
      bmiresult = bmi.toStringAsFixed(1);
      category = cat;
    });
  }

  //dispose of those textediting controller when used and not working....///
  @override
  void dispose() {
    // TODO: implement dispose

    weightKGController.dispose();
    weightLbsController.dispose();
    heightCMController.dispose();
    heightFeetController.dispose();
    heightInchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          'BMI Calculator',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //here we takes person weight units....//
              Text(
                'Weight Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                child: SegmentedButton<WeightType>(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.teal;
                      } else {
                        return Colors.grey.shade200;
                      }
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => states.contains(WidgetState.selected)
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.teal, width: 1.5),
                      ),
                    ),
                  ),
                  segments: [
                    //here we declare the button segment should be have as we has data type in here.....//segment//..
                    const ButtonSegment<WeightType>(
                      value: WeightType.kg,
                      label: Text('KG'),
                    ),
                    const ButtonSegment<WeightType>(
                      value: WeightType.lbs,
                      label: Text('Pound/Lbs'),
                    ),
                  ],
                  selected: {weightType},
                  //arrow functions for on select change the button selected options.............onselect
                  onSelectionChanged: (value) =>
                      setState(() => weightType = value.first),
                ),
              ),
              SizedBox(height: 10),
              if (weightType == WeightType.kg) ...[
                TextFormField(
                  controller: weightKGController,
                  decoration: InputDecoration(
                    labelText: 'Weight (in KG)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: weightLbsController,
                  decoration: InputDecoration(
                    labelText: 'Weight (in Pounds)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              SizedBox(height: 10),
              //from here start height unit data collection ui process...//
              Text(
                'Height Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              //Switch button create korar jonno segmaentbutton widget neoa hoyese.....//switch button..//
              SizedBox(
                width: double.maxFinite,
                child: SegmentedButton<HeightType>(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.teal;
                      } else {
                        return Colors.grey.shade200;
                      }
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => states.contains(WidgetState.selected)
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.teal, width: 1.5),
                      ),
                    ),
                  ),
                  segments: [
                    //here we declare the button segment should be have as we has data type in here.....//segment//..
                    const ButtonSegment<HeightType>(
                      value: HeightType.cm,
                      label: Text('CM'),
                    ),
                    const ButtonSegment<HeightType>(
                      value: HeightType.feetInch,
                      label: Text('Feet/Inch'),
                    ),
                  ],
                  selected: {heightType},
                  //arrow functions for on select change the button selected options.............onselect
                  onSelectionChanged: (value) =>
                      setState(() => heightType = value.first),
                ),
              ),
              SizedBox(height: 7),
              if (heightType == HeightType.cm) ...[
                TextFormField(
                  controller: heightCMController,
                  decoration: InputDecoration(
                    labelText: 'Height (in cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: heightFeetController,
                        decoration: InputDecoration(
                          labelText: 'Feet( \' )',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: heightInchController,
                        decoration: InputDecoration(
                          labelText: 'Inchis( " )',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )
                ),
                onPressed: _calculator,
                child: Text('Show Result',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Card(
                  color: bmiColor(double.tryParse(bmiresult ?? '')?? 0.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Result BMI: ${bmiresult}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                          ),
                        ),
                        SizedBox(height: 7),
                        //this for image to show dynamically....//
                        bmiImage(double.tryParse(bmiresult ?? '')?? 0.0),
                        //..............//
                        SizedBox(height: 7),
                        Text('Category: $category',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
