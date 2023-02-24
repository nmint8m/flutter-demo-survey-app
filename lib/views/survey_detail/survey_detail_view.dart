import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kayla_flutter_ic/di/di.dart';
import 'package:kayla_flutter_ic/gen/assets.gen.dart';
import 'package:kayla_flutter_ic/usecases/survey/get_survey_detail_use_case.dart';
import 'package:kayla_flutter_ic/utils/app_bar_ext.dart';
import 'package:kayla_flutter_ic/views/survey_detail/skeleton_loading/survey_detail_skeleton_loading.dart';
import 'package:kayla_flutter_ic/views/survey_detail/survey_detail_state.dart';
import 'package:kayla_flutter_ic/views/survey_detail/survey_detail_ui_model.dart';
import 'package:kayla_flutter_ic/views/survey_detail/survey_detail_view_model.dart';

final surveyDetailViewModelProvider =
    StateNotifierProvider.autoDispose<SurveyDetailViewModel, SurveyDetailState>(
  (_) => SurveyDetailViewModel(getIt.get<GetSurveyDetailUseCase>()),
);

class SurveyDetailView extends ConsumerStatefulWidget {
  final String surveyId;

  const SurveyDetailView({
    required this.surveyId,
    super.key,
  });

  @override
  SurveyDetailViewState createState() => SurveyDetailViewState();
}

class SurveyDetailViewState extends ConsumerState<SurveyDetailView>
    with TickerProviderStateMixin {
  AppBar get _appBar => AppBarExt.appBarWithBackButton(context: context);

  Widget get _background => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Consumer(
          builder: (_, ref, __) {
            final state = ref.watch(surveyDetailViewModelProvider);
            return state.maybeWhen(
              orElse: () => _defaultBackground,
              success: (uiModel) => FadeInImage.assetNetwork(
                placeholder: Assets.images.nimbleBackground.path,
                image: uiModel.imageUrl,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            );
          },
        ),
      );

  Widget get _defaultBackground =>
      Image(image: Assets.images.nimbleBackground.image().image);

  Widget _mainBody(SurveyDetailUiModel uiModel) => Consumer(
        builder: (_, ref, __) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uiModel.title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  uiModel.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(140, 56)),
                      onPressed: () {},
                      child: const Text('Start survey'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  Widget get _emptyBody => Container();

  Widget get _body => Consumer(
        builder: (_, ref, __) {
          final state = ref.watch(surveyDetailViewModelProvider);
          return state.maybeWhen(
            orElse: () => _emptyBody,
            loading: () => const SurveyDetailSkeletonLoading(),
            success: (uiModel) => _mainBody(uiModel),
          );
        },
      );

  @override
  void initState() {
    super.initState();
    _fetchSurvey();
  }

  Widget get _background => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Consumer(builder: (_, ref, __) {
          // TODO: - Network image stream
          return Image(image: Assets.images.nimbleBackground.image().image);
        }),
      );

  Widget get _mainBody => Consumer(
        builder: (_, ref, __) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // TODO: - Remove hard code
                  "Bonchon Chicken",
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  // TODO: - Remove hard code
                  "Do you wanna take a bite? Mlem.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(140, 56)),
                      onPressed: () {},
                      child: const Text('Start survey'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  Widget get _body => Consumer(
        builder: (_, ref, __) {
          // TODO: - Remove hard code for loading
          return Stack(
            children: [
              _mainBody,
              const SurveyDetailSkeletonLoading(),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _background,
        Container(color: Colors.black38),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _appBar,
          body: SafeArea(child: _body),
        )
      ],
    );
  }

  void _fetchSurvey() {
    ref
        .read(surveyDetailViewModelProvider.notifier)
        .fetchSurvey(widget.surveyId);
  }
}
