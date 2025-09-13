class CompteUtilisateur {
  final String numeroTelephone;
  final String motDePasse;
  final String nom;
  final List<CompteBancaire> comptesBancaires;

  CompteUtilisateur({
    required this.numeroTelephone,
    required this.motDePasse,
    required this.nom,
    required this.comptesBancaires,
  });

  double get soldeTotal {
    return comptesBancaires.fold(0.0, (sum, compte) => sum + compte.solde);
  }

  factory CompteUtilisateur.fromString(String data) {
    final lines = data.trim().split('\n');
    if (lines.isEmpty) {
      throw Exception('Données invalides');
    }

    final userInfo = lines[0].split('|');
    if (userInfo.length != 3) {
      throw Exception('Format utilisateur invalide');
    }

    final numeroTelephone = userInfo[0];
    final motDePasse = userInfo[1];
    final nom = userInfo[2];

    final comptesBancaires = <CompteBancaire>[];
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim().isNotEmpty) {
        comptesBancaires.add(CompteBancaire.fromString(lines[i]));
      }
    }

    return CompteUtilisateur(
      numeroTelephone: numeroTelephone,
      motDePasse: motDePasse,
      nom: nom,
      comptesBancaires: comptesBancaires,
    );
  }
}

class CompteBancaire {
  final String numeroCompte;
  final String typeCompte;
  final double solde;

  CompteBancaire({
    required this.numeroCompte,
    required this.typeCompte,
    required this.solde,
  });

  factory CompteBancaire.fromString(String line) {
    final parts = line.split('|');
    if (parts.length != 3) {
      throw Exception('Format compte bancaire invalide');
    }

    return CompteBancaire(
      numeroCompte: parts[0],
      typeCompte: parts[1].trim(),
      solde: double.parse(parts[2]),
    );
  }

  String get typeCompteFormate {
    if (typeCompte.contains('CHEQUES')) {
      return 'Compte Chèques';
    } else if (typeCompte.contains('EPARGNE')) {
      return 'Compte Épargne';
    }
    return typeCompte;
  }

  bool get isPositiveBalance => solde > 0;
}
