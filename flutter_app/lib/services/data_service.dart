import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/compte_utilisateur.dart';

class DataService {
  static Future<List<CompteUtilisateur>> loadAccountsFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return parseAccountsData(response.body);
      } else {
        throw Exception('Erreur de chargement des données');
      }
    } catch (e) {
      // Fallback: utiliser les données d'exemple
      return loadSampleAccounts();
    }
  }

  static List<CompteUtilisateur> parseAccountsData(String data) {
    final accounts = <CompteUtilisateur>[];
    final sections = data.split('\n\n');
    
    for (final section in sections) {
      if (section.trim().isNotEmpty) {
        try {
          accounts.add(CompteUtilisateur.fromString(section));
        } catch (e) {
          print('Erreur parsing compte: $e');
        }
      }
    }
    
    return accounts;
  }

  static List<CompteUtilisateur> loadSampleAccounts() {
    const sampleData = '''237655389916|123456|NYADA GERMAIN
10005-00021-06640921051-05|COMPTES CHEQUES               |-257.0
10005-00021-06640921101-49|COMPTES EPARGNE SUR LIVRET    |25000.0

237691864087|123456|STEPHEN NJIE NDUMBE
10005-00027-09358121051-70|COMPTES CHEQUES               |268.0

237699996187|1234|BOUBA SOULEYMANOU
10005-00103-09618401051-06|COMPTES CHEQUES               |64845.0

237699550391|123456|REINE DUCHAMPS VOULA
10005-00088-09623741051-72|COMPTES CHEQUES               |0.0

237699882455|123456|HOTOUO CLAUDINE
10005-00007-06085031101-87|COMPTES EPARGNE SUR LIVRET    |30618.0
10005-00007-06085031051-43|COMPTES CHEQUES               |168764.0
10005-00007-06085031052-40|COMPTES CHEQUES               |534.0

237699820169|123456|YONKEU NJINKEU GUY
10005-00003-05389321101-62|COMPTES EPARGNE SUR LIVRET    |106313.0

237696140652|123456|ESTELLE EBOMB
10005-00028-04499441101-61|COMPTES EPARGNE SUR LIVRET    |59026.0''';

    return parseAccountsData(sampleData);
  }
}
