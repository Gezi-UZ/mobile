import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_state.dart';
import '../widgets/register_step_1.dart';
import '../widgets/register_step_2.dart';
import '../widgets/register_step_3.dart';
import '../../../../core/theme/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is RegisterStep1Success) {
                _nextPage(1);
              } else if (state is RegisterStep2Success) {
                _nextPage(2);
              } else if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conta criada com sucesso!')),
                );
                context.go('/home');
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Disable swipe to force flow
                    children: [
                      RegisterStep1(),
                      RegisterStep2(),
                      RegisterStep3(),
                    ],
                  ),
                  if (state is RegisterLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryOrange),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
