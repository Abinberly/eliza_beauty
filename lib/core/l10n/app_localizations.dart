import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ELIZA'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Beauty. Style. Everything.'**
  String get appTagline;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome;

  /// No description provided for @signInDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your curated selection.'**
  String get signInDesc;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @accQuery.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get accQuery;

  /// No description provided for @createAcc.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAcc;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailHint;

  /// No description provided for @registerDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your curated journey today.'**
  String get registerDesc;

  /// No description provided for @alreadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyDesc;

  /// No description provided for @passRemember.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get passRemember;

  /// No description provided for @backToLog.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLog;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @prdDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get prdDetails;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @confirmPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPass;

  /// No description provided for @confirmPassHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPassHint;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailRecLinkDec.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a recovery link.'**
  String get emailRecLinkDec;

  /// No description provided for @errEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'*Email is required'**
  String get errEmailRequired;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'*Name is required'**
  String get errNameRequired;

  /// No description provided for @errEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'*Invalid email format'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'*Password is required'**
  String get errPasswordRequired;

  /// No description provided for @errPasswordMatching.
  ///
  /// In en, this message translates to:
  /// **'*\'Passwords do not match\''**
  String get errPasswordMatching;

  /// No description provided for @errPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'*Minimum 6 characters required'**
  String get errPasswordShort;

  /// No description provided for @errPasswordComplexity.
  ///
  /// In en, this message translates to:
  /// **'*Password must include uppercase, lowercase, a number, and a special character.'**
  String get errPasswordComplexity;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeText;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found.'**
  String get noProductsFound;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @genericBrand.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get genericBrand;

  /// No description provided for @addedToCartSuffix.
  ///
  /// In en, this message translates to:
  /// **' added to Eliza cart!'**
  String get addedToCartSuffix;

  /// No description provided for @reviewsSuffix.
  ///
  /// In en, this message translates to:
  /// **' reviews'**
  String get reviewsSuffix;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkout;

  /// No description provided for @addItemsToCartContinue.
  ///
  /// In en, this message translates to:
  /// **'Add item to cart to continue'**
  String get addItemsToCartContinue;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmpty;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'MEMBER'**
  String get member;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Addresses'**
  String get shippingAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethod;

  /// No description provided for @preference.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preference;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @deliveryUpdates.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on your deliveries'**
  String get deliveryUpdates;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loginToAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Please log in to add items to cart'**
  String get loginToAddToCart;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// No description provided for @limitedEdition.
  ///
  /// In en, this message translates to:
  /// **'LIMITED EDITION'**
  String get limitedEdition;

  /// No description provided for @newEraHeadline.
  ///
  /// In en, this message translates to:
  /// **'A New Era of\n'**
  String get newEraHeadline;

  /// No description provided for @comfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get comfort;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'Minimalist aesthetics meet peak functional performance in our latest curated series.'**
  String get heroDescription;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Product} other{{count} Products}}'**
  String productCount(num count);

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortByPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortByPrice;

  /// No description provided for @sortByRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortByRating;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProductsHint;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get searchProduct;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found matching \"{query}\"'**
  String noItemsFound(Object query);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @customerExperience.
  ///
  /// In en, this message translates to:
  /// **'Customer Experience'**
  String get customerExperience;

  /// No description provided for @newSeasonArrival.
  ///
  /// In en, this message translates to:
  /// **'NEW SEASON ARRIVAL'**
  String get newSeasonArrival;

  /// No description provided for @discountPercent.
  ///
  /// In en, this message translates to:
  /// **'-{percentage}% OFF'**
  String discountPercent(Object percentage);

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({count, plural, =0{No reviews} =1{1 Review} other{{count} Reviews}})'**
  String ratingSummary(num count, Object rating);

  /// No description provided for @productHighlights.
  ///
  /// In en, this message translates to:
  /// **'Product Highlights'**
  String get productHighlights;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @manufacturerInfo.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer Info'**
  String get manufacturerInfo;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @manufacturerNotice.
  ///
  /// In en, this message translates to:
  /// **'This product is manufactured and distributed by {brand}. Quality checked and certified under {sku} standards.'**
  String manufacturerNotice(Object brand, Object sku);

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @similarProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similarProducts;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'REMOVE'**
  String get remove;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @careerDetails.
  ///
  /// In en, this message translates to:
  /// **'Career Details'**
  String get careerDetails;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @jobDescription.
  ///
  /// In en, this message translates to:
  /// **'{title} at {dept}'**
  String jobDescription(Object dept, Object title);

  /// No description provided for @physicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Physical Details'**
  String get physicalDetails;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @ageValue.
  ///
  /// In en, this message translates to:
  /// **'{count} yrs'**
  String ageValue(Object count);

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @heightValue.
  ///
  /// In en, this message translates to:
  /// **'{value} cm'**
  String heightValue(Object value);

  /// No description provided for @weightValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String weightValue(Object value);

  /// No description provided for @atmosphereLabel.
  ///
  /// In en, this message translates to:
  /// **'ATMOSPHERE'**
  String get atmosphereLabel;

  /// No description provided for @atmosphereTitle.
  ///
  /// In en, this message translates to:
  /// **'The Art of Comfort'**
  String get atmosphereTitle;

  /// No description provided for @atmosphereSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Redefining domestic serenity.'**
  String get atmosphereSubtitle;

  /// No description provided for @olfactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'OLFACTIVE'**
  String get olfactiveLabel;

  /// No description provided for @olfactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Luxury Scents'**
  String get olfactiveTitle;

  /// No description provided for @olfactiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invisible signatures for the home.'**
  String get olfactiveSubtitle;

  /// No description provided for @formsLabel.
  ///
  /// In en, this message translates to:
  /// **'FORMS'**
  String get formsLabel;

  /// No description provided for @formsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sculptural Living'**
  String get formsTitle;

  /// No description provided for @formsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where function meets fine art.'**
  String get formsSubtitle;

  /// No description provided for @audioLabel.
  ///
  /// In en, this message translates to:
  /// **'AUDIO'**
  String get audioLabel;

  /// No description provided for @audioTitle.
  ///
  /// In en, this message translates to:
  /// **'Future of Sound'**
  String get audioTitle;

  /// No description provided for @audioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Immersive precision engineering.'**
  String get audioSubtitle;

  /// No description provided for @newNarratives.
  ///
  /// In en, this message translates to:
  /// **'New Narratives'**
  String get newNarratives;

  /// No description provided for @editorsChoice.
  ///
  /// In en, this message translates to:
  /// **'EDITOR\'S CHOICE'**
  String get editorsChoice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
