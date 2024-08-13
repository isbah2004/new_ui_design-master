import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/data_provider.dart';
import 'package:ui_design/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:ui_design/screens/audioscreen/audio_screen.dart';
import 'package:ui_design/screens/docscreen/doc_screen.dart';
import 'package:ui_design/screens/mediaplayers/audio_player.dart';
import 'package:ui_design/screens/mediaplayers/doc_viewer.dart';
import 'package:ui_design/screens/mediaplayers/video_player.dart';
import 'package:ui_design/screens/quotescreen/quote_screen.dart';
import 'package:ui_design/screens/videoscreen/video_screen.dart';
import 'package:ui_design/theme/theme.dart';
import 'package:ui_design/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    List<VoidCallback> navigatorList = [
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AudioScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuoteScreen(),
          ),
        );
      },
    ];
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 50),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 90,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: navigatorList[index],
                    child: Card(
                      elevation: 10,
                      child: SizedBox(
                        height: 80,
                        child: Image(
                          image: AssetImage(
                            Constants.iconList[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(top: 5),
                child: dataProvider.isLoading
                    ? const Center(
                        child: MulticolorProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: dataProvider.combinedList.length,
                        itemBuilder: (context, index) {
                          var item = dataProvider.combinedList[index];
                          String fileType = item['fileName'].split('.').last;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                fileType == 'pdf'
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PdfViewer(url: item['url'])))
                                    : fileType == 'mp3'
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioPlayerScreen(
                                                      url: item['url'],
                                                      title: item['title'],
                                                    )))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayerScreen(
                                                      url: item['url'],
                                                      title: item['title'],
                                                    )));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 20, right: 5, left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.accentColor),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 7),
                                          child: SizedBox(
                                              height: 22,
                                              child: Image.asset(
                                                fileType == 'pdf'
                                                    ? Constants
                                                        .documentLeadingIcon
                                                    : fileType == 'mp3'
                                                        ? Constants
                                                            .audioLeadingIcon
                                                        : Constants
                                                            .videoLeadingIcon,
                                              )),
                                        ),
                                        Text(
                                          item['title'],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
