import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/compte_utilisateur.dart';
import '../services/api_service.dart';

class WithdrawalScreen extends StatefulWidget {
  final CompteUtilisateur account;
  final CompteBancaire bankAccount;

  const WithdrawalScreen({
    super.key,
    required this.account,
    required this.bankAccount,
  });

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0)} XAF';
  }

  Future<void> _processWithdrawal() async {
    final amount = double.tryParse(_amountController.text.replaceAll(',', ''));
    final phone = _phoneController.text.trim();

    if (amount == null || amount <= 0) {
      _showError('Veuillez saisir un montant valide');
      return;
    }

    if (amount > widget.bankAccount.solde) {
      _showError('Montant supérieur au solde disponible');
      return;
    }

    if (phone.isEmpty || phone.length < 9) {
      _showError('Veuillez saisir un numéro de téléphone valide');
      return;
    }

    // Vérifier que le mot de passe du compte bancaire fait 6 chiffres
    if (widget.account.motDePasse.length != 6 || !RegExp(r'^\d{6}$').hasMatch(widget.account.motDePasse)) {
      _showError('Le mot de passe du compte bancaire doit contenir 6 chiffres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Étape 1: Connexion
      final token = await ApiService.login(
        widget.account.numeroTelephone,
        widget.account.motDePasse,
      );

      if (token == null) {
        _showError('Erreur de connexion');
        setState(() => _isLoading = false);
        return;
      }

      // Étape 2: Bank to Wallet
      final bankToWalletSuccess = await ApiService.bankToWalletWithdrawal(
        token: token,
        bankAccount: widget.bankAccount.numeroCompte,
        password: widget.account.motDePasse,
        amount: amount.toString(),
        phoneNumber: widget.account.numeroTelephone,
      );

      if (!bankToWalletSuccess) {
        _showError('Erreur lors du transfert vers le portefeuille');
        setState(() => _isLoading = false);
        return;
      }

      // Étape 3: Wallet to Phone
      final walletToPhoneSuccess = await ApiService.walletToPhoneWithdrawal(
        token: token,
        amount: amount.toString(),
        beneficiaryPhone: phone,
        password: widget.account.motDePasse,
      );

      setState(() => _isLoading = false);

      if (walletToPhoneSuccess) {
        _showSuccess();
      } else {
        _showError('Erreur lors du transfert vers le bénéficiaire');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Erreur lors du traitement: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retrait Réussi'),
        content: Text(
          'Le retrait de ${_formatCurrency(double.parse(_amountController.text.replaceAll(',', '')))} '
          'vers ${_phoneController.text} a été effectué avec succès.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Retrait d\'Argent',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélection initiation
            const Text(
              'Sélection initiation',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            
            // Compte source
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Compte source',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Solde du compte
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.bankAccount.typeCompteFormate,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    _formatCurrency(widget.bankAccount.solde),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Montant du retrait
            const Text(
              'Montant du retrait',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 24),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          // Strip any existing commas before parsing
                          final raw = newValue.text.replaceAll(',', '');
                          final number = int.tryParse(raw);
                          if (number == null) return oldValue;
                          final formatted = number.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          );
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.dialpad, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clavier numérique',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            
            // Où souhaitez-vous retirer cet argent ?
            const Text(
              'Où souhaitez-vous retirer cet argent ?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Option de retrait (uniquement transfert mobile pour le moment)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Transfert vers portefeuille mobile',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Limites de retrait quotidiennes/mensuelles',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            
            // Numéro de téléphone bénéficiaire
            const Text(
              'Numéro de téléphone bénéficiaire',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Ex: 650485614',
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processWithdrawal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Continuer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
