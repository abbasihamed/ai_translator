import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_translator/blocs/text_scan_bloc/text_scan_bloc.dart';

class TextReviewScreen extends StatelessWidget {
  final String imagePath;

  const TextReviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextScanBloc()..add(ProcessImageEvent(imagePath)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Review Scanned Text')),
        body: BlocBuilder<TextScanBloc, TextScanState>(
          builder: (context, state) {
            if (state is TextScanLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TextScanError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            if (state is TextScanLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: state.scannedText,
                        ),
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Edit the scanned text if needed',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          context.read<TextScanBloc>().add(
                            UpdateScannedTextEvent(text),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, state.scannedText);
                          },
                          child: const Text('Use Text'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
}
