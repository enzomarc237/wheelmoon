enum StatutRetrait { enAttente, valide, refuse }

class Retrait {
  final String compteSource;
  final double montant;
  final String numeroBeneficiaire;
  final StatutRetrait statut;
  final DateTime dateCreation;

  Retrait({
    required this.compteSource,
    required this.montant,
    required this.numeroBeneficiaire,
    required this.statut,
    required this.dateCreation,
  });
}
