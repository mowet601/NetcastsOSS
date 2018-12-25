import 'package:flutter/material.dart';
import 'package:swagger/api.dart';

import 'package:hear2learn/common/horizontal_list_view.dart';
import 'package:hear2learn/subscriptions/index.dart';
import 'package:hear2learn/episode/index.dart';
import 'package:hear2learn/models/episode.dart';
import 'package:hear2learn/podcast/index.dart';
import 'package:hear2learn/search/index.dart';
import 'package:hear2learn/settings/index.dart';

const MAX_SHOWCASE_LIST_SIZE = 20;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const titles = [ 'Your Podcasts', 'Top Podcasts', 'New', 'Trending', 'Recommended' ];
    var podcastApiService = new PodcastApi();
    var toplistFuture = podcastApiService.getTopPodcasts(MAX_SHOWCASE_LIST_SIZE, scaleLogo: 200);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int idx) {
          return buildHorizontalList(toplistFuture, title: titles[idx]);
        },
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(),
        shrinkWrap: true,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: DrawerHeader(
                child: Text('Debug Menu'),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ListTile(
              title: Text('Homepage'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            ListTile(
              title: Text('Your Podcasts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Search'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PodcastSearch()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalList(Future<List<Podcast>> toplistFuture, {String title}) {
    return FutureBuilder(
      future: toplistFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Podcast>> snapshot) {
        List<HorizontalListTile> tiles = snapshot.hasData
          ? snapshot.data.map((podcast) =>
            HorizontalListTile(
              image: podcast.scaledLogoUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PodcastPage(
                    url: podcast.url,
                  )),
                );
              },
              title: podcast.title,
            )
          ).toList()
          : [];

        // TODO: REMOVE - temporary MOCK data
        tiles.shuffle();

        return HorizontalListViewCard(
          title: title != null ? title : 'Top Podcasts',
          children: tiles,
        );
      },
    );
  }
}

