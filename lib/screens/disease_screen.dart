import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/digital_twin_provider.dart';

class DiseaseScreen
    extends StatefulWidget {
  const DiseaseScreen({
    super.key,
  });

  @override
  State<DiseaseScreen> createState() =>
      _DiseaseScreenState();
}

class _DiseaseScreenState
    extends State<DiseaseScreen> {
  final ImagePicker _picker =
      ImagePicker();

  Uint8List? _imageBytes;

  String? _fileName;

  Future<void> _pickImage() async {
    final image =
        await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) {
      return;
    }

    final bytes =
        await image.readAsBytes();

    setState(() {
      _imageBytes = bytes;
      _fileName = image.name;
    });
  }

  Future<void> _predict() async {
    if (_imageBytes == null ||
        _fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Select a rice image first.',
          ),
        ),
      );

      return;
    }

    await context
        .read<DigitalTwinProvider>()
        .analyzeDisease(
          imageBytes: _imageBytes!,
          fileName: _fileName!,
        );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<
        DigitalTwinProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        final result =
            provider.diseaseResult;

        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Text(
                'AI Disease Detection',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                provider.backendConnected
                    ? 'AI Backend Connected'
                    : 'AI Backend Offline',
              ),

              const SizedBox(
                height: 20,
              ),

              Container(
                height: 320,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors
                        .grey.shade300,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                clipBehavior:
                    Clip.antiAlias,
                child: _imageBytes == null
                    ? const Center(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize
                                  .min,
                          children: [
                            Icon(
                              Icons
                                  .add_photo_alternate_outlined,
                              size: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Select a rice leaf image',
                            ),
                          ],
                        ),
                      )
                    : Image.memory(
                        _imageBytes!,
                        fit:
                            BoxFit.contain,
                      ),
              ),

              const SizedBox(
                height: 15,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                        OutlinedButton.icon(
                      onPressed:
                          provider
                                  .analyzingImage
                              ? null
                              : _pickImage,
                      icon: const Icon(
                        Icons.image,
                      ),
                      label:
                          const Text(
                        'Select Image',
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          provider
                                  .analyzingImage
                              ? null
                              : _predict,
                      icon: const Icon(
                        Icons
                            .auto_awesome,
                      ),
                      label:
                          const Text(
                        'Predict Disease',
                      ),
                    ),
                  ),
                ],
              ),

              if (provider
                  .analyzingImage) ...[
                const SizedBox(
                  height: 20,
                ),

                const LinearProgressIndicator(),

                const SizedBox(
                  height: 8,
                ),

                const Center(
                  child: Text(
                    'AI model is analyzing the image...',
                  ),
                ),
              ],

              if (provider.diseaseError !=
                  null) ...[
                const SizedBox(
                  height: 20,
                ),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      15,
                    ),
                    child: Text(
                      provider
                          .diseaseError!,
                      style:
                          const TextStyle(
                        color:
                            Colors.red,
                      ),
                    ),
                  ),
                ),
              ],

              if (result.confidence >
                  0) ...[
                const SizedBox(
                  height: 25,
                ),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          result.isHealthy
                              ? Icons
                                  .check_circle
                              : Icons
                                  .warning_rounded,
                          size: 60,
                          color: result
                                  .isHealthy
                              ? Colors.green
                              : Colors.orange,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          result.disease,
                          style: Theme.of(
                            context,
                          )
                              .textTheme
                              .headlineMedium,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Confidence: '
                          '${result.confidencePercent.toStringAsFixed(2)}%',
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        LinearProgressIndicator(
                          value: result
                              .confidence,
                          minHeight: 12,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'Top Predictions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        ...result
                            .topPredictions
                            .map(
                          (
                            prediction,
                          ) {
                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 15,
                              ),
                              child:
                                  Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            Text(
                                          prediction
                                              .disease,
                                        ),
                                      ),
                                      Text(
                                        '${prediction.confidencePercent.toStringAsFixed(2)}%',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        5,
                                  ),

                                  LinearProgressIndicator(
                                    value:
                                        prediction
                                            .confidence,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}