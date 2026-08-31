// lib/services/bhashini_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Data model representing the response from Bhashini's Indic pipeline.
class BhashiniPipelineResult {
  final String sourceText;
  final String translatedText;
  final String? audioBase64;
  final String sourceLanguage;
  final String targetLanguage;

  BhashiniPipelineResult({
    required this.sourceText,
    required this.translatedText,
    this.audioBase64,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

/// Production service class for Government of India's Bhashini (NLTM) APIs.
/// Bridges ASR (Speech-to-Text), NMT (Machine Translation), and TTS (Text-to-Speech).
class BhashiniService {
  static const String _ulcaConfigUrl =
      'https://meity-auth.ulca.in/ulca/apis/v0/model/getModelsPipeline';

  // Securely injected credentials or API constants
  static String apiKey = 'BHASHINI_INFERRED_AUTH_KEY';
  static String userId = 'BHASHINI_USER_IDENTIFIER';
  static String pipelineId = '64392f96daac500b55c543d'; // Indic Multilingual Pipeline

  static String? _cachedInferenceUrl;
  static String? _cachedAuthKey;

  /// Supported Bhashini Indic Language Codes
  static const Map<String, String> indicLanguageCodes = {
    'English': 'en',
    'Hindi': 'hi',
    'Bengali': 'bn',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Marathi': 'mr',
    'Gujarati': 'gu',
    'Kannada': 'kn',
    'Malayalam': 'ml',
    'Odia': 'or',
    'Punjabi': 'pa',
    'Assamese': 'as',
    'Sanskrit': 'sa',
  };

  /// Initializes and fetches dynamic inference endpoints from MeitY Bhashini Gateway.
  static Future<void> initializePipeline() async {
    try {
      final response = await http.post(
        Uri.parse(_ulcaConfigUrl),
        headers: {
          'Content-Type': 'application/json',
          'userID': userId,
          'ulcaApiKey': apiKey,
        },
        body: jsonEncode({
          "pipelineTasks": [
            {
              "taskType": "asr",
              "config": {"language": {"sourceLanguage": "hi"}}
            },
            {
              "taskType": "translation",
              "config": {
                "language": {"sourceLanguage": "hi", "targetLanguage": "en"}
              }
            },
            {
              "taskType": "tts",
              "config": {"language": {"sourceLanguage": "en"}}
            }
          ],
          "pipelineRequestConfig": {"pipelineId": pipelineId}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _cachedInferenceUrl = data['pipelineInferenceAPIEndPoint']?['callbackUrl'];
        _cachedAuthKey = data['pipelineInferenceAPIEndPoint']?['inferenceApiKey']?['value'];
        debugPrint('[BhashiniService] Pipeline initialized successfully.');
      }
    } catch (e) {
      debugPrint('[BhashiniService] Initialization warning (offline fallback): $e');
    }
  }

  /// Translates text across any pair of Indic languages using Bhashini NMT.
  static Future<String> translateIndicText({
    required String text,
    required String sourceLangCode,
    required String targetLangCode,
  }) async {
    if (sourceLangCode == targetLangCode) return text;

    final inferenceUrl = _cachedInferenceUrl ??
        'https://dhruva-api.bhashini.gov.in/services/inference/pipeline';

    try {
      final response = await http.post(
        Uri.parse(inferenceUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _cachedAuthKey ?? apiKey,
        },
        body: jsonEncode({
          "pipelineTasks": [
            {
              "taskType": "translation",
              "config": {
                "language": {
                  "sourceLanguage": sourceLangCode,
                  "targetLanguage": targetLangCode,
                }
              }
            }
          ],
          "inputData": {
            "input": [
              {"source": text}
            ]
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final translated = data['pipelineResponse']?[0]?['output']?[0]?['target'];
        return translated ?? text;
      }
    } catch (e) {
      debugPrint('[BhashiniService] NMT translation error: $e');
    }
    return text; // Graceful fallback
  }

  /// Synthesizes speech (TTS) for the given Indic text and returns base64 audio.
  static Future<String?> synthesizeIndicAudio({
    required String text,
    required String languageCode,
    String gender = 'female',
  }) async {
    final inferenceUrl = _cachedInferenceUrl ??
        'https://dhruva-api.bhashini.gov.in/services/inference/pipeline';

    try {
      final response = await http.post(
        Uri.parse(inferenceUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _cachedAuthKey ?? apiKey,
        },
        body: jsonEncode({
          "pipelineTasks": [
            {
              "taskType": "tts",
              "config": {
                "language": {"sourceLanguage": languageCode},
                "gender": gender
              }
            }
          ],
          "inputData": {
            "input": [
              {"source": text}
            ]
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['pipelineResponse']?[0]?['audio']?[0]?['audioContent'];
      }
    } catch (e) {
      debugPrint('[BhashiniService] TTS synthesis error: $e');
    }
    return null;
  }
}
