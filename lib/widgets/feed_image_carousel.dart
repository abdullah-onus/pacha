import 'package:flutter/material.dart';
import 'package:pacha/constants.dart';
import 'carousel_image/carousel_slider.dart';

class FeedImageCarousel extends StatefulWidget {
  final List<dynamic> image;
  const FeedImageCarousel({Key? key, required this.image}) : super(key: key);
  @override
  State<FeedImageCarousel> createState() => _FeedImageCarouselState();
}

class _FeedImageCarouselState extends State<FeedImageCarousel> {
  late List<dynamic> list;
  @override
  void initState() {
    list = widget.image;
    super.initState();
  }

  final CarouselController _controller = CarouselController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              items: list
                  .map(
                    (item) => Center(
                      child: Image.network(
                        item['url'],
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.height,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, exception, stackTrace) {
                          return Center(child: Image.asset('assets/logo.png'));
                        },
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                enlargeCenterPage: true,
                initialPage: 0,
                aspectRatio: list[_current]['width'] / list[_current]['height'],
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                pageSnapping: true,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                autoPlay: false,
              ),
            ),
            Visibility(
              visible: widget.image.length == 1 ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.image.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: Constants().padding, horizontal: Constants().padding / 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key ? Theme.of(context).indicatorColor : Theme.of(context).disabledColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
