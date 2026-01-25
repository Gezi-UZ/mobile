import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/led_bloc.dart';
import '../bloc/led_event.dart';
import '../bloc/led_state.dart';
import '../widgets/led_button.dart';

class LedControlPage extends StatefulWidget {
  const LedControlPage({super.key});

  @override
  State<LedControlPage> createState() => _LedControlPageState();
}

class _LedControlPageState extends State<LedControlPage> {
  @override
  void initState() {
    super.initState();
    // Load LED states when page opens
    context.read<LedBloc>().add(LoadAllLedsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciyera - LED Control'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LedBloc>().add(LoadAllLedsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<LedBloc, LedState>(
        listener: (context, state) {
          if (state is LedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LedLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LedLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'LEDs',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        LedButton(
                          ledId: 'led_red',
                          label: 'Red LED',
                          isOn: state.leds['led_red'] ?? false,
                          color: Colors.red,
                          onToggle: () {
                            context.read<LedBloc>().add(
                              ToggleLedEvent(
                                ledId: 'led_red',
                                state: !(state.leds['led_red'] ?? false),
                              ),
                            );
                          },
                        ),
                        LedButton(
                          ledId: 'led_green',
                          label: 'Green LED',
                          isOn: state.leds['led_green'] ?? false,
                          color: Colors.green,
                          onToggle: () {
                            context.read<LedBloc>().add(
                              ToggleLedEvent(
                                ledId: 'led_green',
                                state: !(state.leds['led_green'] ?? false),
                              ),
                            );
                          },
                        ),
                        LedButton(
                          ledId: 'led_blue',
                          label: 'Blue LED',
                          isOn: state.leds['led_blue'] ?? false,
                          color: Colors.blue,
                          onToggle: () {
                            context.read<LedBloc>().add(
                              ToggleLedEvent(
                                ledId: 'led_blue',
                                state: !(state.leds['led_blue'] ?? false),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('Tap refresh to load LEDs'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<LedBloc>().add(LoadAllLedsEvent());
                  },
                  child: const Text('Load LEDs'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
