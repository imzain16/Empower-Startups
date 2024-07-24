import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  title: const Text("H O M E"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 8,),

              // Post Page
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.verified,
                    color: Colors.grey,
                  ),
                  title: const Text("P O S T"),
                  onTap: (){
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/post_page');
                    },
                ),
              ),

              const SizedBox(height: 8,),

              // Bidding Pag
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.money,
                    color: Colors.grey,
                  ),
                  title: const Text("BID NOW"),
                  onTap: (){
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/bidding_page');
                  },
                ),
              ),

              const SizedBox(height: 8,),

              // Show all register Users
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    color: Colors.grey,
                  ),
                  title: const Text("C H A T"),
                  onTap: (){
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/show_users_page');
                  },
                ),
              ),

              const SizedBox(height: 8,),

              // Subscribe Now
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.slideshow,
                    color: Colors.grey,
                  ),
                  title: const Text("P L A N S ->"),
                  onTap: (){
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/subscription_page');
                  },
                ),
              ),
            ],
          ),

          // Logout Tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: const Text("LOG OUT"),
              onTap: (){
                Navigator.pop(context);

                _logout();
                },
            ),
          ),
        ],
      ),
    );
  }
}
