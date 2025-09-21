// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:get/get.dart';
import 'package:trustgov/views/voting/choose_election_view.dart';
import '../views/complaint/complaint_view.dart';

import '../views/complaint/create_complaint_view.dart';
import '../views/contract/contract_completed_view.dart';
import '../views/contract/fill_contract_info_view.dart';
import '../views/contract/finalize_contract_view.dart';
import '../views/contract/join_contract_link_view.dart';
import '../views/contract/send_contract_link_view.dart';
import '../views/election_result_view.dart';
import '../views/home/home_view.dart';
import '../views/reset_password/reset_password_view.dart';
import '../views/settings/personal_info_view.dart';
import '../views/signup/account_created_view.dart';
import '../views/splash/splash_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/login/login_view.dart';
import '../views/signup/signup1_view.dart';
import '../views/signup/signup2_view.dart';
import '../views/settings/settings_view.dart';
import '../views/voting/choose_candidate_view.dart';
import '../views/voting/verify_identity_view.dart';
import '../views/voting/voted_successfully_view.dart';
import '../views/home/notification_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup1 = '/signup1';
  static const String signup2 = '/signup2';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String stats = '/stats';
  static const String settings = '/settings';
  static const String personalInfo = '/personal-info';
  static const String choose_election = '/choose-election';
  static const String chooseCandidate = '/choose-candidate';
  static const String verifyIdentity = '/verify-identity';
  static const String votedSuccessfully = '/voted-successfully';
  static const String fillContractInfo = '/fill-contract-info';
  static const String sendContractLink = '/send-contract-link';
  static const String joinContractLink = '/join-contract-link';
  static const String finalizeContract = '/finalize-contract';
  static const String contractCompleted = '/contract-completed';
  static const String accountcreated = '/account-created';
  static const String notifications = '/notifications';
  static const String complaints = '/complaints';
  static const String createComplaint = '/create-complaint';

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: onboarding, page: () => const OnboardingView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signup1, page: () => SignUp1View()),
    GetPage(name: signup2, page: () => SignUp2View()),
    GetPage(name: resetPassword, page: () => ResetPasswordView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: stats, page: () => ElectionResultView()),
    GetPage(name: settings, page: () => const SettingsView()),
    GetPage(name: personalInfo, page: () => PersonalInfoView()),
    GetPage(
      name: chooseCandidate,
      page: () => ChooseCandidateView(),
    ),
    GetPage(
      name: choose_election,
      page: () => ChooseElectionView(),
    ),
    GetPage(name: verifyIdentity, page: () => VerifyIdentityView()),
    GetPage(name: votedSuccessfully, page: () => const VotedSuccessfullyView()),
    GetPage(
      name: fillContractInfo,
      page: () => FillContractInfoView(),
    ),
    GetPage(name: sendContractLink, page: () => SendContractLinkView()),
    GetPage(name: joinContractLink, page: () => JoinContractLinkView()),
    GetPage(
      name: finalizeContract,
      page: () => FinalizeContractView(),
    ),
    GetPage(name: contractCompleted, page: () => const ContractCompletedView()),
    GetPage(name: accountcreated, page: () => const AccountCreatedView()),
    GetPage(
      name: notifications,
      page: () => NotificationsView(),
    ),
    GetPage(
      name: complaints,
      page: () => ComplaintsView(),
    ),
    GetPage(
      name: createComplaint,
      page: () => CreateComplaintView(),
    ),
  ];
}
