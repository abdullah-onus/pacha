import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pacha/widgets/carousel_image/carousel_slider.dart';

class GalleryViewPage extends StatefulWidget {
  const GalleryViewPage({Key? key, required this.path, required this.onImagesSend}) : super(key: key);
  final List<String> path;
  final Function onImagesSend;
  @override
  _GalleryViewPageState createState() => _GalleryViewPageState();
}

class _GalleryViewPageState extends State<GalleryViewPage> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: <Widget>[
          CarouselSlider(
            carouselController: _controller,
            items: widget.path
                .map((item) => Center(
                        child: Image.file(
                      File(item),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      repeat: ImageRepeat.noRepeat,
                      errorBuilder: (context, exception, stackTrace) {
                        return Center(child: Image.asset('assets/logo.png'));
                      },
                    )))
                .toList(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              initialPage: 0,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              pageSnapping: true,
              height: double.infinity,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.path.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key ? Theme.of(context).indicatorColor : Theme.of(context).disabledColor,
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                  onTap: () {
                    widget.onImagesSend(widget.path);
                  },
                  child: const CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.amber,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 27,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
