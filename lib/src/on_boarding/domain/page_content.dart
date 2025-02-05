import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
            image: MediaRes.casualReading,
            title: 'Brand New Curriculum',
            description:
                "This is the first online education platofrom designed by "
                "the world's top professors");

  const PageContent.second()
      : this(
            image: MediaRes.casualLife,
            title: 'A Fun Atmosphere',
            description:
                "This is the first online education platofrom designed by "
                "the world's top professors");

  const PageContent.third()
      : this(
            image: MediaRes.casualMeditationScience,
            title: 'Easy to join Lesson ',
            description:
                "This is the first online education platofrom designed by "
                "the world's top professors");
  final String image;
  final String title;
  final String description;

  @override
  // TODO: implement props
  List<Object?> get props => [image, title, description];
}
