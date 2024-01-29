import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: const Center(child: Text('Flutter Journal')),
          title: const Center(child: Text('Flutter Journal')),
          automaticallyImplyLeading: false,
          elevation: 100,
          flexibleSpace: Container(
            height: double.infinity / 5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white10,
                ],
              ),
            ),
          ),
          // automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 18),
            indicatorColor: Colors.orange,
            dividerColor: Colors.amber,
            tabs: [
              Tab(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Login'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.login)
                    ]),
              ),
              Tab(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                    Text('SignIn'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.person_add,
                    )
                  ]))
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-white.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const TabBarView(
            children: [
              LoginCard(),
              SignupCard(),
            ],
          ),
        ),
      ),
    );
  }
}
