import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace Administrateur'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Statistiques'),
            Tab(text: 'Utilisateurs'),
            Tab(text: 'Trajets'),
            Tab(text: 'Paramètres'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatisticsTab(),
          _buildUsersTab(),
          _buildTripsTab(),
          _buildSettingsTab(),
        ],
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Passager'),
            onTap: () {
              Navigator.pushNamed(context, '/passager');
            },
          ),
          ListTile(
            leading: Icon(Icons.drive_eta),
            title: Text('Conducteur'),
            onTap: () {
              Navigator.pushNamed(context, '/conducteur');
            },
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Administrateur'),
            onTap: () {
              Navigator.pushNamed(context, '/administrateur');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return Center(
      child: Text('Vue d\'ensemble des statistiques de l\'application'),
    );
  }

  Widget _buildUsersTab() {
    return Center(
      child: Text('Gestion des utilisateurs'),
    );
  }

  Widget _buildTripsTab() {
    return Center(
      child: Text('Gestion des trajets'),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Text('Paramètres de l\'application'),
    );
  }
}