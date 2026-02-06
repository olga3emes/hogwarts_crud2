import 'package:flutter/material.dart';
import 'package:hogwarts_crud2/screens/wizard_list_screen.dart';
import 'package:hogwarts_crud2/screens/house_list_screen.dart';
import 'package:hogwarts_crud2/screens/wand_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hogwarts CRUD'),
        centerTitle: true,
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20,
        
        children: [

          _buildHomeCard(
            context, // es un objeto nuevo porque no existe el widgets y lo que construir
            title:"Magos",
            icon: Icons.rowing,
            color: Colors.blue,
            target: const WizardListScreen(),

            ), 
            _buildHomeCard(   context, // es un objeto nuevo porque no existe el widgets y lo que construir
            title:"Casas",
            icon: Icons.castle,
            color: const Color.fromARGB(255, 227, 7, 69),
            target: const HouseListScreen(),
            ),
            _buildHomeCard(   context, // es un objeto nuevo porque no existe el widgets y lo que construir
            title:"Varitas",
            icon: Icons.auto_fix_high,
            color: const Color.fromARGB(255, 208, 33, 243),
            target: const WandListScreen(),),
        ],
        
        ),
      ) 
    );
  }

Widget _buildHomeCard(
  BuildContext context,{
    required String title,
    required IconData icon,
    required Color color,
    required Widget target,
  }){
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => target)
      ),

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withValues(alpha: 0.3), //transparencia 30%
            //esto es para que el fondo del botón sea un color pastel, con poca opacidad
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono grande
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 12), //  br
              // Texto
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

      )

    );
  }




}// end class

