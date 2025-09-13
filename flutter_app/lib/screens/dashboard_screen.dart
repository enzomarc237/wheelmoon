import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/compte_utilisateur.dart';
import '../services/data_service.dart';
import '../utils/format.dart';
import 'accounts_list_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<CompteUtilisateur> _accounts = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      setState(() => _isLoading = true);
      
      // Essayer de charger depuis une URL si définie, sinon utiliser les données d'exemple
      const accountsUrl = String.fromEnvironment('ACCOUNTS_URL');
      List<CompteUtilisateur> accounts;
      
      if (accountsUrl.isNotEmpty) {
        accounts = await DataService.loadAccountsFromUrl(accountsUrl);
      } else {
        accounts = DataService.loadSampleAccounts();
      }
      
      setState(() {
        _accounts = accounts;
        _isLoading = false;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur de chargement des données';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  double get _totalBalance {
    return _accounts.fold(0.0, (sum, account) => sum + account.soldeTotal);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAccounts,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête utilisateur
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Utilisateur',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Solde total
                      const Text(
                        'Solde Total Combiné',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        FormatUtils.formatCurrencyWithSeparators(_totalBalance),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Masquer/Afficher'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Actions rapides
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccountsListScreen(accounts: _accounts),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D3748),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Voir Comptes'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Retrait'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Dépôt'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Actions rapides
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Action Rapide',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Afficher'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Statistiques des comptes
                      _buildAccountStats(),
                      
                      const SizedBox(height: 24),
                      
                      // Navigation inférieure
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(Icons.home, 'Accueil', true),
                            _buildNavItem(Icons.swap_horiz, 'Transactions', false),
                            _buildNavItem(Icons.payment, 'Paiements', false),
                            _buildNavItem(Icons.person, 'Profil', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAccountStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Compte Chèques',
                FormatUtils.formatCurrency(_getBalanceByType('CHEQUES')),
                Colors.red[400]!,
                'Derniers 4 chiffres masqués',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Compte Épargne',
                FormatUtils.formatCurrency(_getBalanceByType('EPARGNE')),
                Colors.grey[400]!,
                'Derniers 4 chiffres masqués',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Compte Chèques',
                FormatUtils.formatCurrency(_getBalanceByType('CHEQUES') * 0.6),
                const Color(0xFF2D3748),
                'Solde 4 derniers',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Compte Épargne',
                FormatUtils.formatCurrency(_getBalanceByType('EPARGNE') * 0.8),
                Colors.teal[400]!,
                'Solde 4 derniers',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String amount, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  double _getBalanceByType(String type) {
    double total = 0;
    for (final account in _accounts) {
      for (final bankAccount in account.comptesBancaires) {
        if (bankAccount.typeCompte.contains(type)) {
          total += bankAccount.solde;
        }
      }
    }
    return total;
  }
}
