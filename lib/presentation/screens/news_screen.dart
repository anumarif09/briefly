import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/news_bloc.dart';
import '../../bloc/news_event.dart';
import '../../bloc/news_state.dart';
import '../widgets/news_card.dart';
import '../widgets/share_daily_brief_sheet.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<NewsBloc>().add(LoadNews());
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Tech',
        'query': 'technology',
        'color': Colors.lime,
        'textColor': Colors.black,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: 'Briefly',

            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),

            children: <TextSpan>[
              TextSpan(
                text: '.',

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.lime,
                ),
              ),
            ],
          ),
        ),

        centerTitle: false,

        elevation: 0,

        backgroundColor: Colors.transparent,

        actions: [
          IconButton(
            onPressed: () {
              context.read<NewsBloc>().add(LoadGeminiNews("technology"));
            },

            icon: const Icon(Icons.auto_awesome),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),

          const CircleAvatar(child: Icon(Icons.person_2_outlined)),

          const SizedBox(width: 16),
        ],
      ),

      floatingActionButton: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          final newsCount = state is NewsLoaded ? state.news.length : 5;

          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,

                isScrollControlled: true,

                backgroundColor: Colors.transparent,

                isDismissible: false,

                builder: (BuildContext context) {
                  return ShareDailyBriefSheet(newsCount: newsCount);
                },
              );
            },

            shape: const CircleBorder(),

            child: const Icon(Icons.share_outlined),
          );
        },
      ),

      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading || state is NewsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is GeminiNewsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(LoadGeminiNews("technology"));
              },

              child: ListView(
                padding: const EdgeInsets.all(16),

                children: [
                  // CATEGORY CHIPS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: List.generate(categories.length, (i) {
                        final category = categories[i];

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),

                          child: GestureDetector(
                            onTap: () {
                              context.read<NewsBloc>().add(
                                LoadGeminiNews(category['query']),
                              );
                            },

                            child: Chip(
                              label: Text(
                                category['label'],

                                style: TextStyle(
                                  color: category['textColor'] ?? Colors.white,
                                ),
                              ),

                              backgroundColor: category['color'],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.black87,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.lime),

                            SizedBox(width: 10),

                            Text(
                              "✨ AI Curated Tech Brief",

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          state.summary,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NewsLoaded) {
            final news = state.news;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(LoadNews());
              },

              child: ListView.builder(
                padding: EdgeInsets.zero,

                itemCount: news.length + 2,

                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),

                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,

                        child: Row(
                          children: List.generate(categories.length, (i) {
                            final category = categories[i];

                            return Padding(
                              padding: const EdgeInsets.only(left: 16),

                              child: GestureDetector(
                                onTap: () {
                                  context.read<NewsBloc>().add(
                                    LoadGeminiNews(category['query']),
                                  );
                                },

                                child: Chip(
                                  label: Text(
                                    category['label'],

                                    style: TextStyle(
                                      color:
                                          category['textColor'] ?? Colors.white,
                                    ),
                                  ),

                                  backgroundColor: category['color'],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  } else if (index == 1) {
                    return const SizedBox(height: 8);
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: NewsCard(item: news[index - 2]),
                    );
                  }
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
