import 'package:beebusy_app/constants/app_constants.dart';
import 'package:beebusy_app/constants/asset_path.dart';
import 'package:beebusy_app/ui/pages/login_page.dart';
import 'package:beebusy_app/ui/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  static const String route = '/onboarding';
  OnBoardingPage({Key key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: 
   Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
            controller: controller,
            onPageChanged: (int index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: <Widget>[
              buildOnBoardingPage(
                  color: Colors.white,
                  urlImage: ImageVectorPath.addTasks,
                  title: 'Organisiert an einer Stelle',
                  subtitle: 'Arbeiten von zu Hause aus war nie einfacher, alles ist an einem Ort organisiert'),
              buildOnBoardingPage(
                  color: Colors.white,
                  urlImage: ImageVectorPath.completedTasks,
                  title: 'Colloborate',
                  subtitle: 'Bleiben Sie mit Ihren Teammitgliedern in Verbindung und laden Sie sie zu einem Projekt ein'),
              buildOnBoardingPage(
                  color: Colors.white,
                  urlImage: ImageVectorPath.goodTeam,
                  title: 'Projekt auf Kurs halten',
                  subtitle: 'Erledigen Sie Ihre Aufgaben, tracken Sie Ihren Fortschritt und arbeiten Sie besser mit Ihrem Team zusammen'),
            ]),
      ),
      bottomSheet: isLastPage
          ? Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: _getStartedButton(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 90,
              child: Row(
                mainAxisAlignment: width <= 820 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    }, 
                    child: const Text('SKIP')
                    ),
                  Center(
                    child: SmoothPageIndicator(
                        onDotClicked: (int index) {
                          controller.animateToPage(index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        controller: controller,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            dotHeight: 12.0,
                            dotWidth: 10.0,
                            dotColor: Colors.grey.shade300,
                            activeDotColor: kSecondaryColor),
                      ),
                  ),
                  _nextButton()
                ],
              ),
            ),
    );
  }

  /* ----------------------------------------------> COMPONENTS <-------------------------------------- */

  Widget _getStartedButton() => Container(
        height: 90,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius)),
            primary: Colors.white,
            backgroundColor: kSecondaryColor,
            minimumSize: const Size.fromHeight(90),
          ),
          child: const BrownText(
            'BeeBusy',
            fontSize: 24,
          ),
          onPressed: () async {
            final GetStorage prefs = GetStorage();
            prefs.write('showLogin', true);

            Get.toNamed<void>(LoginPage.route);
          },
        ),
      );

  Widget _nextButton() => Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            color: kSecondaryColor),
        child: IconButton(
          tooltip: 'Nächster Schritt',
          padding: const EdgeInsets.all(12.0),
          splashColor: kPrimaryColor,
          color: kSecondaryColor,
          icon: const Icon(
            Icons.arrow_forward,
            color: kColorWhite,
            size: 20,
          ),
          onPressed: () async {
           controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
        ),
      );

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
          children: <Widget>[
            Container(
              height: 350,
              constraints: MediaQuery.of(context).size.width <= 820 ? const BoxConstraints(maxWidth: 350) : const BoxConstraints(maxWidth: 450),
              child: 
              SvgPicture.asset(
                     urlImage,
                      fit: BoxFit.contain,
                    ),
            ),
            BrownText(
              title,
              isBold: true,
              fontSize: 32,
            ),
            const SizedBox(
              height: kSpacing,
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.55,
                  fontSize: 16,
                  color: Color(0xFF1b1b1b)
                ),
              ),
            )
          ],
        ),
      );
}
