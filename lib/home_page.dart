import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/feature/form/presentation/pages/form_page.dart';
import 'package:flutter_clean_architecture/feature/product/presentation/pages/product_page.dart';
import 'package:flutter_clean_architecture/feature/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_clean_architecture/feature/product/presentation/bloc/product_event.dart';
import '../../../../main.dart';
import 'feature/audio_player/presentation/pages/audio_list_page.dart'; // for accessing sl (service locator)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const FormPage(),
      BlocProvider(
        create: (_) => sl<ProductBloc>()..add(FetchProducts()),
        child: const ProductPage(),
      ),
       AudioListPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppPallete.gradient2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Audio',
          ),
        ],
      ),
    );
  }
}
