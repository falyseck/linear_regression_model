import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> with SingleTickerProviderStateMixin {
  final TextEditingController addictionController = TextEditingController(text: '5');
  double addictionScore = 5.0;
  String result = "";
  bool loading = false;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    addictionController.addListener(() {
      final v = double.tryParse(addictionController.text);
      if (v != null && v >= 1 && v <= 10) {
        setState(() {
          addictionScore = v;
        });
      }
    });
  }

  @override
  void dispose() {
    addictionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> getPrediction() async {
    final double? score = double.tryParse(addictionController.text);

    if (score == null || score < 1 || score > 10) {
      setState(() {
        result = "Please enter a valid addiction score (1–10).";
      });
      return;
    }

    setState(() {
      loading = true;
      result = '';
    });

    final url = Uri.parse("https://mental-health-prediction-app-oj0d.onrender.com/predict");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"addicted_score": score}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = "Predicted Mental Health Score: ${data['predicted_mental_health_score']}";
        });
      } else {
        setState(() {
          result = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        result = "API Connection Failed";
      });
    } finally {
      setState(() {
        loading = false;
      });
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Predictor'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Addiction Score',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addictionController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Addiction Score (1–10)',
                                hintText: 'e.g. 5.0',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              addictionScore.toStringAsFixed(1),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        value: addictionScore.clamp(1.0, 10.0),
                        min: 1,
                        max: 10,
                        divisions: 18,
                        label: addictionScore.toStringAsFixed(1),
                        onChanged: (v) {
                          setState(() {
                            addictionScore = v;
                            addictionController.text = v.toStringAsFixed(1);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : getPrediction,
                          icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.analytics),
                          label: Text(loading ? 'Predicting...' : 'Predict'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizeTransition(
                sizeFactor: CurvedAnimation(parent: _animController, curve: Curves.easeOut),
                axisAlignment: -1.0,
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        if (result.isEmpty)
                          Text('No result yet. Enter a score and tap Predict.', style: TextStyle(color: Colors.grey[600]))
                        else
                          Text(result, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Tip: Use the slider for quick input, or type a precise value.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
