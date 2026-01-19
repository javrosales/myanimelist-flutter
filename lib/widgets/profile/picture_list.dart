import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PictureList extends StatelessWidget {
  const PictureList(this.pictures);

  final List<Picture> pictures;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Pictures', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: pictures.length,
            itemBuilder: (context, index) {
              Picture picture = pictures.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Ink.image(
                  image: NetworkImage(picture.largeImageUrl ?? picture.imageUrl),
                  width: kImageWidthM,
                  height: kImageHeightM,
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageScreen(pictures.map((i) => i.largeImageUrl ?? i.imageUrl).toList(), index),
                          settings: const RouteSettings(name: 'ImageScreen'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class ImageScreen extends StatefulWidget {
  const ImageScreen(this.imagePaths, this.currentIndex);

  final List<String> imagePaths;
  final int currentIndex;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          _buildPhotoViewGallery(),
          if (widget.imagePaths.length > 1) _buildDotIndicator(),
        ],
      ),
    );
  }

  Widget _buildPhotoViewGallery() {
    return PhotoViewGallery.builder(
      pageController: _pageController,
      itemCount: widget.imagePaths.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.imagePaths[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        );
      },
      loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
      scrollPhysics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildDotIndicator() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SmoothPageIndicator(
          controller: _pageController,
          count: widget.imagePaths.length,
          effect: const WormEffect(
            dotWidth: 6.0,
            dotHeight: 6.0,
            spacing: 6.0,
            dotColor: Colors.grey,
            activeDotColor: kMyAnimeListColor,
          ),
        ),
      ),
    );
  }
}
