import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  static const String route = '/onboarding';
  OnBoardingPage({Key key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: [
              buildOnBoardingPage(
                  color: Colors.green.shade100,
                  urlImage: 'images/ebook.png',
                  title: 'Colloborate',
                  subtitle: 'Colloborations was never that easy'),
              buildOnBoardingPage(
                  color: Colors.blue.shade100,
                  urlImage: 'images/ebook.png',
                  title: 'Colloborate',
                  subtitle: 'Colloborations was never that easy'),
              buildOnBoardingPage(
                  color: Colors.red.shade100,
                  urlImage: 'images/ebook.png',
                  title: 'Colloborate',
                  subtitle: 'Colloborations was never that easy'),
            ]),
      ),
      bottomSheet: isLastPage
          ? TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: kSecondaryColor,
              minimumSize: const Size.fromHeight(90),
            ),
              child: const BrownText(
                'Get started',
                fontSize: 24,
              ),
              onPressed: () async {
                Get.toNamed<void>(LoginPage.route);
              },
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(2);
                      },
                      child: const Text('SKIP')),
                  Center(
                    child: SmoothPageIndicator(
                      onDotClicked: (int index) {
                        controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      controller: controller,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                          activeDotColor: kPrimaryColor),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: const Text('NEXT'))
                ],
              ),
            ),
    );
  }

  Widget buildOnBoardingPage({
    @required Color color,
    @required String urlImage,
    @required String title,
    @required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(
              height: kSpacing * 2,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: kSpacing,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                subtitle,
              ),
            )
          ],
        ),
      );
}
