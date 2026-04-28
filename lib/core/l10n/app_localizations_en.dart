// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ELIZA';

  @override
  String get appTagline => 'Beauty. Style. Everything.';

  @override
  String get welcome => 'Welcome Back';

  @override
  String get signInDesc => 'Sign in to access your curated selection.';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get accQuery => 'Don\'t have an account?';

  @override
  String get createAcc => 'Create Account';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get registerDesc => 'Start your curated journey today.';

  @override
  String get alreadyDesc => 'Already have an account?';

  @override
  String get passRemember => 'Remember your password?';

  @override
  String get backToLog => 'Back to Login';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get prdDetails => 'Product Details';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get cart => 'Cart';

  @override
  String get account => 'Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get confirmPass => 'Confirm Password';

  @override
  String get confirmPassHint => 'Re-enter your password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailRecLinkDec => 'Enter your email to receive a recovery link.';

  @override
  String get errEmailRequired => '*Email is required';

  @override
  String get errNameRequired => '*Name is required';

  @override
  String get errEmailInvalid => '*Invalid email format';

  @override
  String get errPasswordRequired => '*Password is required';

  @override
  String get errPasswordMatching => '*\'Passwords do not match\'';

  @override
  String get errPasswordShort => '*Minimum 6 characters required';

  @override
  String get errPasswordComplexity =>
      '*Password must include uppercase, lowercase, a number, and a special character.';

  @override
  String get welcomeText => 'Welcome';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get noProductsFound => 'No products found.';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get genericBrand => 'Generic';

  @override
  String get addedToCartSuffix => ' added to Eliza cart!';

  @override
  String get reviewsSuffix => ' reviews';

  @override
  String get off => 'OFF';

  @override
  String get checkout => 'Check Out';

  @override
  String get addItemsToCartContinue => 'Add item to cart to continue';

  @override
  String get cartEmpty => 'Cart is empty';

  @override
  String get member => 'MEMBER';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get shippingAddress => 'Shipping Addresses';

  @override
  String get paymentMethod => 'Payment Methods';

  @override
  String get preference => 'Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get deliveryUpdates => 'Stay updated on your deliveries';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get languages => 'Languages';

  @override
  String get logOut => 'Log Out';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get loginToAddToCart => 'Please log in to add items to cart';

  @override
  String get adding => 'Adding...';

  @override
  String get limitedEdition => 'LIMITED EDITION';

  @override
  String get newEraHeadline => 'A New Era of\n';

  @override
  String get comfort => 'Comfort';

  @override
  String get heroDescription =>
      'Minimalist aesthetics meet peak functional performance in our latest curated series.';

  @override
  String productCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Products',
      one: '1 Product',
    );
    return '$_temp0';
  }

  @override
  String get sortByName => 'Name';

  @override
  String get sortByPrice => 'Price';

  @override
  String get sortByRating => 'Rating';

  @override
  String get searchProductsHint => 'Search products...';

  @override
  String get searchProduct => 'Search product';

  @override
  String noItemsFound(Object query) {
    return 'No items found matching \"$query\"';
  }

  @override
  String get categories => 'Categories';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get customerExperience => 'Customer Experience';

  @override
  String get newSeasonArrival => 'NEW SEASON ARRIVAL';

  @override
  String discountPercent(Object percentage) {
    return '-$percentage% OFF';
  }

  @override
  String ratingSummary(num count, Object rating) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Reviews',
      one: '1 Review',
      zero: 'No reviews',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get productHighlights => 'Product Highlights';

  @override
  String get specifications => 'Specifications';

  @override
  String get manufacturerInfo => 'Manufacturer Info';

  @override
  String get brand => 'Brand';

  @override
  String get sku => 'SKU';

  @override
  String get weight => 'Weight';

  @override
  String get dimensions => 'Dimensions';

  @override
  String get availability => 'Availability';

  @override
  String manufacturerNotice(Object brand, Object sku) {
    return 'This product is manufactured and distributed by $brand. Quality checked and certified under $sku standards.';
  }

  @override
  String get myCart => 'My Cart';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get similarProducts => 'Similar Products';

  @override
  String get remove => 'REMOVE';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get careerDetails => 'Career Details';

  @override
  String get role => 'Role';

  @override
  String get jobTitle => 'Job Title';

  @override
  String jobDescription(Object dept, Object title) {
    return '$title at $dept';
  }

  @override
  String get physicalDetails => 'Physical Details';

  @override
  String get age => 'Age';

  @override
  String ageValue(Object count) {
    return '$count yrs';
  }

  @override
  String get bloodGroup => 'Blood Group';

  @override
  String get height => 'Height';

  @override
  String heightValue(Object value) {
    return '$value cm';
  }

  @override
  String weightValue(Object value) {
    return '$value kg';
  }

  @override
  String get atmosphereLabel => 'ATMOSPHERE';

  @override
  String get atmosphereTitle => 'The Art of Comfort';

  @override
  String get atmosphereSubtitle => 'Redefining domestic serenity.';

  @override
  String get olfactiveLabel => 'OLFACTIVE';

  @override
  String get olfactiveTitle => 'Luxury Scents';

  @override
  String get olfactiveSubtitle => 'Invisible signatures for the home.';

  @override
  String get formsLabel => 'FORMS';

  @override
  String get formsTitle => 'Sculptural Living';

  @override
  String get formsSubtitle => 'Where function meets fine art.';

  @override
  String get audioLabel => 'AUDIO';

  @override
  String get audioTitle => 'Future of Sound';

  @override
  String get audioSubtitle => 'Immersive precision engineering.';

  @override
  String get newNarratives => 'New Narratives';

  @override
  String get editorsChoice => 'EDITOR\'S CHOICE';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get networkErrorTitle => 'No Internet Connection';

  @override
  String get networkErrorMessage =>
      'Please check your internet connection and try again.';

  @override
  String get networkErrorRetry => 'Retry';

  @override
  String get networkErrorDismiss => 'Dismiss';
}
