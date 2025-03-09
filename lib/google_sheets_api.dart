import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  
  "type": "service_account",
  "project_id": "flutter-gsheets-453217",
  "private_key_id": "0c1cf5f99eeb3be7d0d0e57346d082cae9af0286",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCod5RBg6vzpLpq\nfm2tmsg3F75SSCF/dV3bJAmclj27faZ4pTAGeUSBWuRQ4NMjZ1v0XBZJplvE5UWW\nL7hrMB9e6kZKjeV8UA4781IIP6KQihXaXpP3tpG30o+P7eZsEAXDBbDF/mR0ZUZs\nspvcwLKwKR7ao9lBmkFFEITDOWQislk/bgfYTlI/J4Zb7LcPdvl4kW+eleFAeXrk\neVorKGGwHyx9sC8sWC8rQyAEeyxwr/azr1PI4LHs+fKrxxyXjbGOEtA4HKI2prNE\nnAQzz6dWQyCgnyWPkrNmPOjl6PDWYQ8+9URh2HuPPmo/Uudv1bcuxgZcwsH0JChF\n87l8NfchAgMBAAECggEADPV31stLYphJC7CSfMBzhsNhjUBFrWGImPcOczheYsoB\nUHX6egEBi0bD2dHVg/trKCKeR0eP9xcg0XL1x28B9sHkKs979+JLmgJ3TLGibmZk\n1HGihbNKRb7hcrOc3jKkUtJg/PX64bY5otphYWuEQ0dCe5SPfXuhai/hWogTYxS/\nfTm2v/UcsNWSgfrYIwn0dr1R9kA5dhIGZmL1OXZRFE2wIcrLuxy/olhDQA6Ft4jg\nv6xg0FAufnwlCHotkSj5AOrsCcETCQhqEYr8MGf707wZDK9x6T3WTCIc9Df0yUG3\npQPWTRyexXUMF0m69uP9pUeCKiI/oOYVem5vnKDwHQKBgQDf0AMj8E6a1H28U6fV\nhs+64NXS/gPWM9WlNP7BGzamzIl+um/x/o3/BTy05bNo1EUYWIUbpsiAT94dcSC0\nRZecPW44EhV29O6UwFb5YgNaKecc1HCp/uHxWsscmYO3Q5fBj4Z+07+2gOwa5Nh1\nwkgoPUErtcTnTO10x+TJqy8xbQKBgQDAsfFvmKKW1KSEF2jKOzHgbAv2bg8ra4Zr\n2XtnnkgOQ/DcAzadY2PnC2IJC7k9UU61cwnL1TZUVujZC0+1lD3Ania8WLOoUzQB\n09qEaFeogS4oZXbnfakMy8HGFhbyFpahBJStKEjkB0js/Hdb5kCVzEAjMtJYySzo\nGc7mUTIABQKBgHRu1JNnupzVmqvUoWV2Aq9ntBVVzE0tHiIaFcYEEERp98WT3BT6\npohbAx/gt5r7gw6NToH6HCiUZCrQ5YCjC6JeWu6UidIezddY0GZgVPoc/nyDEDF/\nxa832p6ARoOaiGJL9l4Ybo3VN/8tumZYsg0tALBqmYry/D1amG1Jvv1pAoGBAK0F\nmkKYDTXdzbMFygP8TvayTbOCc4CLVfG1IEeUKiMVAkqrX/jGa8fjwq1Yp4XVYhUv\nLFaoJdZpCz8IFxR1/VTdLO7lvrufqg0SCx3lCwC0rZt8L94ASTDCLEYPQ58whSQj\nltQ8XebSW7rfntUX1FotQlHYqmMqkHX/5nWL5pd5AoGAA/Nt+5NAjoC6Szd3ysnD\nH4bMHWxM4+eO1Ceb1sqMOpqCTtcbG2eOMZBitJDp05hwLxsbZazIDYPbHHPFGsgL\nGQdWB0DVMmYemfZRK8OZ3bC/AV6CxrSaNeTYT6ryDQmWTtFAJKzbRDn2j66ku6gk\nC/FANZSx5ZmwUcfLeqb3Kxs=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@flutter-gsheets-453217.iam.gserviceaccount.com",
  "client_id": "100693053774627986808",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheets-453217.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1w6auwe0BuAkOygHgPtepJt7lX6N88JCykkp0JejyoT4';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
