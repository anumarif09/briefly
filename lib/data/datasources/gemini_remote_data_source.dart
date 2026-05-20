import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiRemoteDataSource {
  Future<String> fetchNewsSummary(String category) async {
    const apiKey = "AIzaSyCIlYcK_lJgoqFoQ0_I_SUWHqn8gMr9M7s";

    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "systemInstruction": {
          "parts": [
            {
              "text":
                  "You are an expert news reporter who curates content and provides a brief to the point response in Pakistani Korangi slang Roman Urdu. You do not give long paragraphs but just some bullet points with the summary.",
            },
          ],
        },

        "contents": [
          {
            "role": "user",

            "parts": [
              {"text": "Latest $category news summary in last 24 hours."},
            ],
          },
        ],

        "tools": [
          {"googleSearch": {}},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      print(response.body);

      throw Exception("Failed to fetch AI news");
    }
  }
}
