import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_test_app/onboarding_data_dao.dart';
import 'package:onboarding_test_app/onboarding_step_wrapper.dart';

import 'onboarding/onboarding_bloc.dart';

void main() async {
  await Hive.initFlutter();
  await OnboardingDataDao().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Portal(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (context) => OnboardingBloc()..add(OnboardingEventLoad()),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('search pressed');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 250,
              color: Colors.pink[300],
              margin: EdgeInsets.all(20),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                itemBuilder: (context, index) {
                  Widget child = Container(
                    height: 120,
                    width: 170,
                    color: Colors.green[200],
                    margin: EdgeInsets.all(10),
                  );
                  if (index == 2) {
                    return OnboardingStepWrapper(
                      step: 1,
                      child: child,
                    );
                  }
                  return child;
                },
              ),
            ),
            OnboardingStepWrapper(
              step: 0,
              child: Padding(
                child: Text('Категории'),
                padding: EdgeInsets.only(left: 20),
              ),
            ),
            Container(
              height: 250,
              color: Colors.pink[200],
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: activeIndex,
          onTap: (int newIndex) {
            if (newIndex != activeIndex) {
              setState(() {
                activeIndex = newIndex;
              });
            }
          },
          unselectedItemColor: Colors.blue[300],
          selectedItemColor: Colors.blue[700],
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_add,
              ),
              label: '1',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check,
              ),
              label: '2',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grading_outlined,
              ),
              label: '3',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.mediation,
              ),
              label: '4',
            ),
          ],
        ),
      ),
    );
  }
}
