import 'package:flutter/material.dart';

void main() {
  runApp(const HaemeCalculatorApp());
}

class HaemeCalculatorApp extends StatelessWidget {
  const HaemeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAEME Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xfff4f7fa),
      ),
      home: const HaemeHomePage(),
    );
  }
}

class HaemeHomePage extends StatefulWidget {
  const HaemeHomePage({super.key});

  @override
  State<HaemeHomePage> createState() => _HaemeHomePageState();
}

class _HaemeHomePageState extends State<HaemeHomePage> {

  String rank = "Hav";
  String macp = "None";

  final ranks = [
    "Nk",
    "Hav",
    "Nb Sub",
    "Sub",
    "Sub Maj"
  ];

  final macps = [
    "None",
    "1st MACP",
    "2nd MACP",
    "3rd MACP"
  ];

  final payLevelController = TextEditingController();
  final basicController = TextEditingController();
  final mspController = TextEditingController();
  final xPayController = TextEditingController();
  final clPayController = TextEditingController();
  final daController = TextEditingController(text: "0");
  final leaveController = TextEditingController(text: "0");
  final commutationController = TextEditingController(text: "0");
  final agiController = TextEditingController(text: "0");
  
  final afppController = TextEditingController(text: "0");
  

  DateTime? doi;
  DateTime? dor;
  DateTime? dob;

  double a = 0;
  double basicPension = 0;
  double fullPension = 0;
  double commutedPortion = 0;
  double pensionAfterCommutation = 0;
  double gratuity = 0;
  double commutationValue = 0;
  double leaveEncashment = 0;
  double totalLumpSum = 0;
  double afppFund = 0;
  ///////part3
  // ======================================
// SERVICE INFORMATION
// ======================================

int ageNextBirthdayResult = 0;

int serviceLengthResult = 0;

int netServiceResult = 0;

double purchaseValueResult = 0;
  //// above is part 3 added

  Future<void> pickDate(bool isDOI, bool isDOR, bool isDOB) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isDOI) doi = picked;
      if (isDOR) dor = picked;
      if (isDOB) dob = picked;
    });
  }

  Widget buildTextField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget resultCard(String title, String value) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.calculate),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void resetAll() {
    setState(() {

      payLevelController.clear();
      basicController.clear();
      mspController.clear();
      xPayController.clear();
      clPayController.clear();

      daController.text = "0";
      leaveController.text = "0";
      commutationController.text = "0";
      agiController.text = "0";

      doi = null;
      dor = null;
      dob = null;

      a = 0;
      basicPension = 0;
      fullPension = 0;
      commutedPortion = 0;
      pensionAfterCommutation = 0;
      gratuity = 0;
      commutationValue = 0;
      leaveEncashment = 0;
      totalLumpSum = 0;
      afppController.text = "0";
    });
  }
///////////yahi ham part 2 dalenge 
  //void calculate() {
    // PART-2 ME DALENGE
  //}
 // ======================================================
// PURCHASE VALUE TABLE
// ======================================================

final Map<int, double> purchaseValueTable = {
  35: 9.145,
  36: 9.136,
  37: 9.126,
  38: 9.116,
  39: 9.103,
  40: 9.090,
  41: 9.075,
  42: 9.059,
  43: 9.040,
  44: 9.019,
  45: 8.996,
  46: 8.971,
  47: 8.943,
  48: 8.913,
  49: 8.881,
  50: 8.846,
  51: 8.808,
  52: 8.768,
  53: 8.724,
  54: 8.678,
  55: 8.627,
  56: 8.572,
  57: 8.512,
  58: 8.446,
  59: 8.371,
  60: 8.287,
  61: 8.194,
};

// ======================================================
// AGE NEXT BIRTHDAY
// ======================================================

int getAgeNextBirthday(DateTime dob, DateTime retirement) {

  int age = retirement.year - dob.year;

  DateTime birthdayThisYear =
      DateTime(retirement.year, dob.month, dob.day);

  if (retirement.isBefore(birthdayThisYear)) {
    return age;
  }

  return age + 1;
}

// ======================================================
// SERVICE LENGTH
// ONLY COMPLETED YEARS
// EXAMPLE:
// 24 YEAR 29 DAYS = 24
// ======================================================

int getServiceLength(DateTime doi, DateTime dor) {

  int years = dor.year - doi.year;

  DateTime anniversary =
      DateTime(dor.year, doi.month, doi.day);

  if (dor.isBefore(anniversary)) {
    years--;
  }

  return years;
}

// ======================================================
// MAIN CALCULATION
// ======================================================

void calculate() {

  if (doi == null || dor == null || dob == null) {
    return;
  }

  double basic =
      double.tryParse(basicController.text) ?? 0;

  double msp =
      double.tryParse(mspController.text) ?? 0;

  double xPay =
      double.tryParse(xPayController.text) ?? 0;

  double clPay =
      double.tryParse(clPayController.text) ?? 0;

  double daPercent =
      double.tryParse(daController.text) ?? 0;

  double commPercent =
      double.tryParse(commutationController.text) ?? 0;

  double leaveDays =
      double.tryParse(leaveController.text) ?? 0;

  double agi =
      double.tryParse(agiController.text) ?? 0;
 double afppFund =
double.tryParse(afppController.text) ?? 0;
  
  
  

  // ==================================
  // A
  // ==================================

  a = basic + msp + xPay + clPay;

  // ==================================
  // BASIC PENSION
  // ==================================

  basicPension = a * 0.50;

  // ==================================
  // DA AMOUNT
  // ==================================

  double daAmount =
      a * daPercent / 100;

  // ==================================
  // FULL PENSION
  // ==================================

  fullPension =
      basicPension +
          (basicPension * daPercent / 100);

  // ==================================
  // COMMUTED PORTION
  // ==================================

  commutedPortion =
      basicPension *
          commPercent / 100;

  // ==================================
  // PENSION AFTER COMMUTATION
  // ==================================

  double reducedBasic =
      basicPension - commutedPortion;

  pensionAfterCommutation =
      reducedBasic +
          (basicPension * daPercent / 100);

  // ==================================
  // SERVICE LENGTH
  // ==================================
serviceLengthResult =
getServiceLength(doi!, dor!);
  

  // ==================================
  // +5 YEAR WEIGHTAGE
  // ==================================

  netServiceResult =
serviceLengthResult + 5;

  // ==================================
  // GRATUITY
  // ==================================

  gratuity =
      (a + daAmount) *
          netServiceResult /
          2;

  // ==================================
  // AGE NEXT BIRTHDAY
  // ==================================

  ageNextBirthdayResult =
getAgeNextBirthday(dob!, dor!); 

  // ==================================
  // PURCHASE VALUE
  // ==================================

  purchaseValueResult =
purchaseValueTable[ageNextBirthdayResult] ?? 8.846;

  // ==================================
  // COMMUTATION VALUE
  // ==================================
commutationValue =
commutedPortion *
12 *
purchaseValueResult;
  

  // ==================================
  // LEAVE ENCASHMENT
  // ==================================

  leaveEncashment =
      ((a + daAmount) / 30) *
          leaveDays;

  // ==================================
  // TOTAL LUMP SUM
  // ==================================

  totalLumpSum =
      gratuity +
          commutationValue +
          leaveEncashment +
          agi +
          afppFund;

  setState(() {});
}
  
 ////////// iske uperror part 2 dale hai
  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DEFENCE PENSION CALCULATOR"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.shield,size: 45),
            ),

            const SizedBox(height: 10),

            const Text(
              "Military Pension & Retirement Estimator",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              value: rank,
              items: ranks.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  rank = v!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Rank",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: macp,
              items: macps.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  macp = v!;
                });
              },
              decoration: const InputDecoration(
                labelText: "MACP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            buildTextField(
                "Pay Level",
                payLevelController,
                Icons.layers),

            buildTextField(
                "Basic Pay",
                basicController,
                Icons.currency_rupee),

            buildTextField(
                "MSP",
                mspController,
                Icons.currency_rupee),

            buildTextField(
                "X Pay",
                xPayController,
                Icons.currency_rupee),

            buildTextField(
                "CL Pay",
                clPayController,
                Icons.currency_rupee),

            buildTextField(
                "DA %",
                daController,
                Icons.percent),

            buildTextField(
                "Leave Days",
                leaveController,
                Icons.calendar_month),

            buildTextField(
                "Commutation %",
                commutationController,
                Icons.pie_chart),

            buildTextField(
                "AGI Contribution",
                agiController,
                Icons.account_balance),
            
            buildTextField(
    "AFPP Fund",
    afppController,
    Icons.savings),
            

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDate(true,false,false),
                    child: Text(
                      doi == null
                          ? "DOI"
                          : "${doi!.day}/${doi!.month}/${doi!.year}",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDate(false,true,false),
                    child: Text(
                      dor == null
                          ? "DOR"
                          : "${dor!.day}/${dor!.month}/${dor!.year}",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => pickDate(false,false,true),
              child: Text(
                dob == null
                    ? "DOB"
                    : "${dob!.day}/${dob!.month}/${dob!.year}",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calculate,
              icon: const Icon(Icons.calculate),
              label: const Text("CALCULATE"),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: resetAll,
              icon: const Icon(Icons.refresh),
              label: const Text("RESET"),
            ),

            const SizedBox(height: 20),

  //
            
            
            
            //=====================================
// SERVICE INFORMATION
// ======================================

resultCard(
  "Age Next Birthday",
  ageNextBirthdayResult.toString(),
),

resultCard(
  "Length of Service",
  "${serviceLengthResult} Year",
),

resultCard(
  "Net Service (+5 Weightage)",
  "${netServiceResult} Year",
),

resultCard(
  "Purchase Value",
  purchaseValueResult.toStringAsFixed(3),
),
            resultCard("Basic Pension", basicPension.toStringAsFixed(0)),
            resultCard("Full Pension", fullPension.toStringAsFixed(0)),
            resultCard("Commuted Portion", commutedPortion.toStringAsFixed(0)),
            resultCard("Pension After Commutation",
                pensionAfterCommutation.toStringAsFixed(0)),
            resultCard("Gratuity", gratuity.toStringAsFixed(0)),
            resultCard("Commutation Value",
                commutationValue.toStringAsFixed(0)),
            resultCard("Leave Encashment",
                leaveEncashment.toStringAsFixed(0)),
            resultCard("Total Lump Sum",
                totalLumpSum.toStringAsFixed(0)),

            const SizedBox(height: 25),

            const Text(
              "Design & Developed by Hav Anuj, Corps of EME",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
