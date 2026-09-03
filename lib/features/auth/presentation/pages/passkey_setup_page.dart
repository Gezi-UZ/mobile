import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_event.dart';
import '../bloc/register/register_state.dart';
import '../widgets/register_step_3.dart';

/// Passkey setup (formerly step 3 of registration).
/// This page is reached after a NEW user successfully signs up.
class PasskeySetupPage extends StatefulWidget {
  const PasskeySetupPage({super.key});

  @override
  State<PasskeySetupPage> createState() => _PasskeySetupPageState();
}

class _PasskeySetupPageState extends State<PasskeySetupPage> {
  late final RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = sl<RegisterBloc>();
    
    // We already have the session propagated to AuthBloc, so we can just trigger passkey setup.
    // However, RegisterBloc still expects OtpVerifiedForRegister to hold the session if we wanted
    // to pass it, but since AuthBloc handles it, we might just use AuthBloc's current session.
    final session = sl<AuthBloc>().state is AuthAuthenticated 
        ? (sl<AuthBloc>().state as AuthAuthenticated).session 
        : null;
        
    if (session != null) {
      _registerBloc.add(OtpVerifiedForRegister(
        phoneNumber: session.email ?? session.phone ?? '',
        session: session,
      ));
    }
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is RegisterSuccess) {
                // Propagate the new session to the global AuthBloc
                context.read<AuthBloc>().add(SessionObtained(state.session));
                context.go('/home');
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  const RegisterStep3(),
                  if (state is RegisterLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryOrange,
                        ),
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
