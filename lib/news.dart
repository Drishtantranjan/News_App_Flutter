import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> result = []; // Use a List of Maps
  bool show = false;

  @override
  void initState() {
    getNewsItems();
    super.initState();
  }

  Future<void> getNewsItems() async {
    try {
      var response = await Dio().post(
          "http://qgo.electreps.com:8080/go/json/fetch/nodes.json",
          data: {
            "platform": "ANDROID",
            "tf": 0,
            "nid": 893975,
            "uid": 0,
            "city": "Bangalore",
            "type": ["statenews", "localnews"],
            "Category": null,
            "lang_code": "kn",
            "device_id": "sdfghfdsdgfvbcxfdgfhgfbds"
          });

      if (response.statusCode == 200) {
        // print(response);
        setState(() {
          print(response.statusCode);
          result = (response.data?['result'])
                  ?.map((item) => {
                        'title': item['title'],
                        'description': item['body_value_original'],
                        'imageUrl': item['image_url'],
                        'videoThumbnail': ['video_thumbnail_url']
                      })
                  .toList() ??
              [];
          print('result');
          print(result[1]['title']);
          print(result[1]['description']);
          print(result[1]['imageUrl']);
          print(result[0]['imageUrl']);
          print(result[1]['videoThumbnail']);
          print('length: ' + result.length.toString());
          // print(response);
        });
        setState(() {
          show = true;
        });
      } else {
        print("HTTP Request Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching news data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Newsify",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          final item = result[index];
          print(index);
          print(item);
          // return Text('data');
          return Card(
            margin: EdgeInsets.all(20),
            elevation: 5,
            shadowColor: Colors.grey,
            color: Colors.white,
            child: Column(
              children: [
                if (item['imageUrl'] != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.network(
                      item['imageUrl'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                if (item['imageUrl'] == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Image.network(
                        'https://media-cldnry.s-nbcnews.com/image/upload/newscms/2019_01/2705191/nbc-social-default.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['title'] ?? 'Null Value',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item['description'][0] ?? 'Null Value'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
