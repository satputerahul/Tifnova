import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tifnova'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @yourOrders.
  ///
  /// In en, this message translates to:
  /// **'Your Orders'**
  String get yourOrders;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get yourAccount;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Account'**
  String get verification;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for meals, kitchens, or dishes'**
  String get searchHint;

  /// No description provided for @exploreByDishes.
  ///
  /// In en, this message translates to:
  /// **'Browse by Dish'**
  String get exploreByDishes;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'Craving something? Search here!'**
  String get whatsOnYourMind;

  /// No description provided for @setLocation.
  ///
  /// In en, this message translates to:
  /// **'Set Delivery Location'**
  String get setLocation;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable location to find nearby kitchens'**
  String get enableLocation;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @fetchingLocality.
  ///
  /// In en, this message translates to:
  /// **'Fetching locality...'**
  String get fetchingLocality;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Access Disabled'**
  String get locationServicesDisabled;

  /// No description provided for @enableLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to find nearby kitchens.'**
  String get enableLocationDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Access Needed'**
  String get permissionRequired;

  /// No description provided for @permissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to discover nearby kitchens in the app settings.'**
  String get permissionDesc;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @exploreKitchens.
  ///
  /// In en, this message translates to:
  /// **'Explore Kitchens'**
  String get exploreKitchens;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty!'**
  String get yourCartIsEmpty;

  /// No description provided for @noMeals.
  ///
  /// In en, this message translates to:
  /// **'No meals added yet. Browse our menu!'**
  String get noMeals;

  /// No description provided for @browseMeals.
  ///
  /// In en, this message translates to:
  /// **'Browse Meals'**
  String get browseMeals;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @discoverSimilarMeals.
  ///
  /// In en, this message translates to:
  /// **'Discover Similar Meals'**
  String get discoverSimilarMeals;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @inclFeesTax.
  ///
  /// In en, this message translates to:
  /// **'(incl. fees and tax)'**
  String get inclFeesTax;

  /// No description provided for @confirmPaymentAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment & Address'**
  String get confirmPaymentAddress;

  /// No description provided for @todaysMenu.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Menu'**
  String get todaysMenu;

  /// No description provided for @viewYourCart.
  ///
  /// In en, this message translates to:
  /// **'View your cart'**
  String get viewYourCart;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmail;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @selectDob.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectDob;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectGender;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated!'**
  String get profileUpdated;

  /// No description provided for @thali.
  ///
  /// In en, this message translates to:
  /// **'Thali'**
  String get thali;

  /// No description provided for @vegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get vegetable;

  /// No description provided for @chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get chicken;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @paratha.
  ///
  /// In en, this message translates to:
  /// **'Paratha'**
  String get paratha;

  /// No description provided for @southIndian.
  ///
  /// In en, this message translates to:
  /// **'South Indian'**
  String get southIndian;

  /// No description provided for @patilMessDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily changing traditional Maharashtrian thali.'**
  String get patilMessDesc;

  /// No description provided for @sadanandDesc.
  ///
  /// In en, this message translates to:
  /// **'Authentic vegetarian snacks and meals.'**
  String get sadanandDesc;

  /// No description provided for @annapurnaDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily home cooked all-you-can-eat.'**
  String get annapurnaDesc;

  /// No description provided for @amrutaDesc.
  ///
  /// In en, this message translates to:
  /// **'Coconut-rich South Indian meals.'**
  String get amrutaDesc;

  /// No description provided for @swadistamDesc.
  ///
  /// In en, this message translates to:
  /// **'Modern North Indian tiffin service.'**
  String get swadistamDesc;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @freeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get freeDelivery;

  /// No description provided for @tifnovaAt.
  ///
  /// In en, this message translates to:
  /// **'Tifnova at'**
  String get tifnovaAt;

  /// No description provided for @yourService.
  ///
  /// In en, this message translates to:
  /// **'your service!'**
  String get yourService;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers to your questions'**
  String get helpSubtitle;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get helpSearchHint;

  /// No description provided for @helpNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get helpNoResults;

  /// No description provided for @helpNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords'**
  String get helpNoResultsSubtitle;

  /// No description provided for @helpStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpStillNeedHelp;

  /// No description provided for @helpCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get helpCall;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get helpEmail;

  /// No description provided for @helpWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get helpWhatsapp;

  /// No description provided for @helpCategoryGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpCategoryGettingStarted;

  /// No description provided for @helpCategoryAccountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & Profile'**
  String get helpCategoryAccountProfile;

  /// No description provided for @helpCategorySubscriptionOrders.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Orders'**
  String get helpCategorySubscriptionOrders;

  /// No description provided for @helpCategoryPaymentRefunds.
  ///
  /// In en, this message translates to:
  /// **'Payment & Refunds'**
  String get helpCategoryPaymentRefunds;

  /// No description provided for @helpCategoryFoodMenu.
  ///
  /// In en, this message translates to:
  /// **'Food & Menu'**
  String get helpCategoryFoodMenu;

  /// No description provided for @faqRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'How to register on Tifnova?'**
  String get faqRegisterTitle;

  /// No description provided for @faqRegisterDesc.
  ///
  /// In en, this message translates to:
  /// **'To register, download the app, click on \'Sign Up\' button, enter your mobile number, verify OTP, and complete your profile.'**
  String get faqRegisterDesc;

  /// No description provided for @faqSearchMessTitle.
  ///
  /// In en, this message translates to:
  /// **'How to search for mess?'**
  String get faqSearchMessTitle;

  /// No description provided for @faqSearchMessDesc.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar on the home screen or browse categories. You can filter by location, price range, and food type.'**
  String get faqSearchMessDesc;

  /// No description provided for @faqSelectMessTitle.
  ///
  /// In en, this message translates to:
  /// **'How to select a mess?'**
  String get faqSelectMessTitle;

  /// No description provided for @faqSelectMessDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse messes, check menu, ratings and reviews, and click \'Subscribe\' to choose your meal plan.'**
  String get faqSelectMessDesc;

  /// No description provided for @faqUpdateProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'How to update my profile?'**
  String get faqUpdateProfileTitle;

  /// No description provided for @faqUpdateProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile section, click edit icons, update information, and tap \'Update Profile\'.'**
  String get faqUpdateProfileDesc;

  /// No description provided for @faqChangeMobileTitle.
  ///
  /// In en, this message translates to:
  /// **'How to change my mobile number?'**
  String get faqChangeMobileTitle;

  /// No description provided for @faqChangeMobileDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Mobile > Enter new number > Verify OTP to update your mobile number.'**
  String get faqChangeMobileDesc;

  /// No description provided for @faqResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'How to reset my password?'**
  String get faqResetPasswordTitle;

  /// No description provided for @faqResetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Click \'Forgot Password\', enter mobile/email, verify OTP, and set new password.'**
  String get faqResetPasswordDesc;

  /// No description provided for @faqSubscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'How to subscribe to a mess?'**
  String get faqSubscribeTitle;

  /// No description provided for @faqSubscribeDesc.
  ///
  /// In en, this message translates to:
  /// **'Select mess, choose meal plan and duration, then complete payment.'**
  String get faqSubscribeDesc;

  /// No description provided for @faqPauseSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I pause my subscription?'**
  String get faqPauseSubscriptionTitle;

  /// No description provided for @faqPauseSubscriptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to My Orders > Active Subscriptions > Pause. Resume anytime.'**
  String get faqPauseSubscriptionDesc;

  /// No description provided for @faqCancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'How to cancel subscription?'**
  String get faqCancelSubscriptionTitle;

  /// No description provided for @faqCancelSubscriptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to My Orders > Active Subscriptions > Cancel. Refund as per policy.'**
  String get faqCancelSubscriptionDesc;

  /// No description provided for @faqOrderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'How to view my order history?'**
  String get faqOrderHistoryTitle;

  /// No description provided for @faqOrderHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to My Orders to see your full past and current subscriptions.'**
  String get faqOrderHistoryDesc;

  /// No description provided for @faqPaymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are accepted?'**
  String get faqPaymentMethodsTitle;

  /// No description provided for @faqPaymentMethodsDesc.
  ///
  /// In en, this message translates to:
  /// **'We accept UPI, Cards, Net Banking, and digital wallets.'**
  String get faqPaymentMethodsDesc;

  /// No description provided for @faqPaymentSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Is my payment information secure?'**
  String get faqPaymentSecurityTitle;

  /// No description provided for @faqPaymentSecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'We use secure gateways. Your payment data is never stored.'**
  String get faqPaymentSecurityDesc;

  /// No description provided for @faqRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'How do refunds work?'**
  String get faqRefundTitle;

  /// No description provided for @faqRefundDesc.
  ///
  /// In en, this message translates to:
  /// **'Refunds take 5–7 business days depending on cancellation policy.'**
  String get faqRefundDesc;

  /// No description provided for @faqDoubleChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'I was charged twice, what should I do?'**
  String get faqDoubleChargeTitle;

  /// No description provided for @faqDoubleChargeDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact support with order ID. Refund will be processed if double charge is confirmed.'**
  String get faqDoubleChargeDesc;

  /// No description provided for @faqCustomizeMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I customize my meals?'**
  String get faqCustomizeMealsTitle;

  /// No description provided for @faqCustomizeMealsDesc.
  ///
  /// In en, this message translates to:
  /// **'Some messes offer custom options like spice level and extras.'**
  String get faqCustomizeMealsDesc;

  /// No description provided for @faqVegVeganTitle.
  ///
  /// In en, this message translates to:
  /// **'Are there vegetarian/vegan options?'**
  String get faqVegVeganTitle;

  /// No description provided for @faqVegVeganDesc.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can filter by Veg, Non-Veg, Vegan, and Jain.'**
  String get faqVegVeganDesc;

  /// No description provided for @faqReportQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'How to report food quality issues?'**
  String get faqReportQualityTitle;

  /// No description provided for @faqReportQualityDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to My Orders > Select order > Report Issue.'**
  String get faqReportQualityDesc;

  /// No description provided for @profileErrorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get profileErrorName;

  /// No description provided for @profileErrorMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get profileErrorMobile;

  /// No description provided for @profileErrorEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get profileErrorEmail;

  /// No description provided for @profileErrorDob.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get profileErrorDob;

  /// No description provided for @profileErrorGender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get profileErrorGender;

  /// No description provided for @fullTiffin.
  ///
  /// In en, this message translates to:
  /// **'Full Tiffin'**
  String get fullTiffin;

  /// No description provided for @bhindiFry.
  ///
  /// In en, this message translates to:
  /// **'Bhindi Fry'**
  String get bhindiFry;

  /// No description provided for @dumAloo.
  ///
  /// In en, this message translates to:
  /// **'Dum Aloo'**
  String get dumAloo;

  /// No description provided for @jeeraRice.
  ///
  /// In en, this message translates to:
  /// **'Jeera Rice'**
  String get jeeraRice;

  /// No description provided for @dal.
  ///
  /// In en, this message translates to:
  /// **'Dal'**
  String get dal;

  /// No description provided for @chapati.
  ///
  /// In en, this message translates to:
  /// **'Chapati'**
  String get chapati;

  /// No description provided for @methiBhaji.
  ///
  /// In en, this message translates to:
  /// **'Methi Bhaji'**
  String get methiBhaji;

  /// No description provided for @tawaPaneer.
  ///
  /// In en, this message translates to:
  /// **'Tawa Paneer'**
  String get tawaPaneer;

  /// No description provided for @kothambirVadi.
  ///
  /// In en, this message translates to:
  /// **'Kothambir Vadi'**
  String get kothambirVadi;

  /// No description provided for @gulabJamun.
  ///
  /// In en, this message translates to:
  /// **'Gulab Jamun'**
  String get gulabJamun;

  /// No description provided for @pureVeg.
  ///
  /// In en, this message translates to:
  /// **'Pure Veg'**
  String get pureVeg;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added any meals yet.'**
  String get cartEmptySubtitle;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
