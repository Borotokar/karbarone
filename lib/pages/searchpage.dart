import 'package:borotokar/controller/ServiceController.dart';
import 'package:borotokar/utils/listoftest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchPage extends StatefulWidget {
  final String val;
  const SearchPage({Key? key, this.val = ""}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final Servicecontroller serviceController = Get.find<Servicecontroller>();
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  bool _isListening = false;

  late AnimationController _eqController;
  late Animation<double> _eqAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchServices();
    });
    _initSpeech();
    _eqController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _eqAnimation = Tween<double>(
      begin: 10,
      end: 30,
    ).animate(CurvedAnimation(parent: _eqController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _eqController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        Get.snackbar('خطا', 'مشکل در فعال‌سازی میکروفون: ${error.errorMsg}');
      },
    );
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      Get.snackbar('خطا', 'دسترسی به میکروفون فعال نیست.');
      return;
    }
    setState(() => _isListening = true);
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "fa-IR",
      listenMode: ListenMode.confirmation,
    );
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _controller.text = result.recognizedWords;
    });
    serviceController.filterServices(result.recognizedWords);
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              // _isListening ? Icons.mic : Icons.mic_none,
              Icons.mic,
              // color: _isListening ? Colors.green : Colors.black,
              color: Colors.green,
              size: 25,
            ),
          ),
          if (_isListening)
            AnimatedBuilder(
              animation: _eqController,
              builder: (context, child) {
                return Row(
                  children: List.generate(4, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: Container(
                        width: 4,
                        height: _eqAnimation.value + (i % 2 == 0 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Obx(() {
            if (serviceController.isLoading.value) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.greenAccent,
                  size: 50,
                ),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  automaticallyImplyLeading: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.greenAccent.withOpacity(0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.search,
                              color: Colors.green,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                autocorrect: true,
                                enableSuggestions: true,
                                name: 'search',
                                controller: _controller,
                                onChanged:
                                    (value) => serviceController.filterServices(
                                      value ?? '',
                                    ),
                                autofocus: true,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "جستجو کنید ...",
                                  hintTextDirection: TextDirection.rtl,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildMicButton(),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 10,
                        runSpacing: 3,
                        children:
                            serviceController.filteredServices
                                .map<Widget>(
                                  (s) => ListCard(
                                    title: s['title'],
                                    image: s['image'],
                                    id: s['id'],
                                    height: 50,
                                    width: 50,
                                    textSize: 8,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
