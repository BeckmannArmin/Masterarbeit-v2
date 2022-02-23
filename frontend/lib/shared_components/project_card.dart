import 'package:flutter/material.dart';



class ProjectCardData {
  final ImageProvider projectImage;

  const ProjectCardData({
    this.projectImage,
  });
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    this.data,
    Key key,
  }) : super(key: key);

  final ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       _ProfilImage(image: data.projectImage)
      ],
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */

class _ProfilImage extends StatelessWidget {
  const _ProfilImage({this.image, Key key}) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: image,
      radius: 20,
      backgroundColor: Colors.white,
    );
  }
}