import 'package:flutter/material.dart';

import 'package:major_project/core/presentation/pages/report_page.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../appwrite/auth_api.dart';
import '../../../constants.dart';
import 'chat_page.dart';
import 'journal_list_page.dart';
import 'login_page.dart';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
          builder: (context) {
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Scaffold(
                key: _key,
                appBar: isSmallScreen ? AppBar(
                  title: Text('Mental Health Analyzer'),
                  leading: IconButton(
                    onPressed: (){
                      _key.currentState?.openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  ),
                ): null,
                drawer: SideBarXExample(controller: _controller,),
                body: Row(
                  children: [
                    if(!isSmallScreen) SideBarXExample(controller: _controller),
                    Expanded(child: Center(child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context,child){
                        switch(_controller.selectedIndex){
                          case 0: _key.currentState?.closeDrawer();
                          return JournalListPage();
                          case 1: _key.currentState?.closeDrawer();
                          return ChatPage();
                          case 2: _key.currentState?.closeDrawer();
                          return ReportPage();
                          case 3: _key.currentState?.closeDrawer();
                          return Center(
                            child: Text('Theme',style: TextStyle(color: canvasColor,fontSize: 40),),
                          );
                          case 4: _key.currentState?.closeDrawer();
                          return Center(
                            child: AlertDialog(
                              title: const Text("Confirm Sign Out",style: TextStyle(color: canvasColor,fontSize: 20),),
                              content: const Text('Are you sure you want to sign out?',style: TextStyle(color: canvasColor,fontSize: 12)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<AuthAPI>(context, listen: false).signOut();
                                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LoginPage()) , (route) => false);
                                    },
                                    child: const Text('Yes',style: TextStyle(color: canvasColor,fontSize: 15)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement<void, void>(
                                          context,
                                          MaterialPageRoute<void>(
                                          builder: (BuildContext context) => const HomePage(),
                                      ));
                                    },
                                    child: const Text('No',style: TextStyle(color: canvasColor,fontSize: 15)),
                                  ),
                                ]
                            )
                          );
                          default:
                            return Center(
                              child: Text('Home',style: TextStyle(color: canvasColor,fontSize: 40),),
                            );
                        }
                      },
                    ),))
                  ],
                )
            );
          }
      ),
    );
  }
}

class SideBarXExample extends StatelessWidget {
  const SideBarXExample({Key? key, required SidebarXController controller}) : _controller = controller,super(key: key);
  final SidebarXController _controller;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme:  const SidebarXTheme(
        decoration: BoxDecoration(
            color: canvasColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))
        ),
        hoverColor: primaryColor,
        hoverIconTheme:  IconThemeData(
          color: primaryColor,
        ),
        iconTheme: IconThemeData(
          color: scaffoldBackgroundColor,
        ),
        selectedTextStyle: const TextStyle(color: canvasColor),
        selectedIconTheme: IconThemeData(
          color: canvasColor,
        ),
        selectedItemDecoration: BoxDecoration(color: scaffoldBackgroundColor),

      ),
      extendedTheme: const SidebarXTheme(
          width: 250
      ),

      footerDivider: Divider(color: scaffoldBackgroundColor, height: 1),
      headerBuilder: (context,extended){
        return const  SizedBox(
          height: 100,
          child: Icon(Icons.person,size: 60,color: scaffoldBackgroundColor,),
        );
      },

      items: const [
        SidebarXItem(icon: Icons.note_alt_outlined, label: 'Journals',),
        SidebarXItem(icon: Icons.chat_bubble_outline_outlined, label: 'Sakha'),
        SidebarXItem(icon: Icons.edit_note, label: 'Report'),
        SidebarXItem(icon: Icons.dark_mode, label: 'Light/Dark Mode'),
        SidebarXItem(icon: Icons.logout, label: 'Sign Out'),
      ],
    );
  }
}