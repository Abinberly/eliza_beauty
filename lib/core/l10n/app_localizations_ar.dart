// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'إليزا';

  @override
  String get appTagline => 'جمال. أناقة. كل شيء.';

  @override
  String get welcome => 'مرحباً بعودتك';

  @override
  String get signInDesc => 'سجل دخولك للوصول إلى مجموعتك المختارة.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get accQuery => 'ليس لديك حساب؟';

  @override
  String get createAcc => 'إنشاء حساب';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get registerDesc => 'ابدأ رحلتك المختارة اليوم.';

  @override
  String get alreadyDesc => 'لديك حساب بالفعل؟';

  @override
  String get passRemember => 'هل تذكرت كلمة المرور؟';

  @override
  String get backToLog => 'العودة لتسجيل الدخول';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get prdDetails => 'تفاصيل المنتج';

  @override
  String get home => 'الرئيسية';

  @override
  String get search => 'بحث';

  @override
  String get cart => 'السلة';

  @override
  String get account => 'الحساب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameHint => 'أدخل اسمك الكامل';

  @override
  String get confirmPass => 'تأكيد كلمة المرور';

  @override
  String get confirmPassHint => 'أعد إدخال كلمة المرور';

  @override
  String get sendResetLink => 'إرسال رابط استعادة الحساب';

  @override
  String get emailRecLinkDec => 'أدخل بريدك الإلكتروني لتلقي رابط الاستعادة.';

  @override
  String get errEmailRequired => '*البريد الإلكتروني مطلوب';

  @override
  String get errNameRequired => '*الاسم مطلوب';

  @override
  String get errEmailInvalid => '*صيغة البريد الإلكتروني غير صحيحة';

  @override
  String get errPasswordRequired => '*كلمة المرور مطلوبة';

  @override
  String get errPasswordMatching => '*كلمات المرور غير متطابقة';

  @override
  String get errPasswordShort => '*مطلوب 6 أحرف على الأقل';

  @override
  String get errPasswordComplexity =>
      '*يجب أن تتضمن كلمة المرور حرفاً كبيراً، وصغيراً، ورقماً، ورمزاً خاصاً.';

  @override
  String get welcomeText => 'مرحباً';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات.';

  @override
  String get errorPrefix => 'خطأ: ';

  @override
  String get genericBrand => 'ماركة عامة';

  @override
  String get addedToCartSuffix => ' تمت إضافته إلى سلة إليزا!';

  @override
  String get reviewsSuffix => ' تقييمات';

  @override
  String get off => 'خصم';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get addItemsToCartContinue => 'أضف عناصر إلى السلة للمتابعة';

  @override
  String get cartEmpty => 'السلة فارغة';

  @override
  String get member => 'عضو';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get shippingAddress => 'عناوين الشحن';

  @override
  String get paymentMethod => 'طرق الدفع';

  @override
  String get preference => 'التفضيلات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get deliveryUpdates => 'ابقَ على اطلاع بمواعيد التوصيل';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get languages => 'اللغات';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get loginToAddToCart => 'يرجى تسجيل الدخول لإضافة المنتجات إلى السلة';

  @override
  String get adding => 'جاري الإضافة...';

  @override
  String get limitedEdition => 'إصدار محدود';

  @override
  String get newEraHeadline => 'عصر جديد من\n';

  @override
  String get comfort => 'الراحة';

  @override
  String get heroDescription =>
      'جماليات التصميم البسيط تلتقي مع قمة الأداء الوظيفي في أحدث مجموعاتنا المختارة.';

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
  String get sortByName => 'الاسم';

  @override
  String get sortByPrice => 'السعر';

  @override
  String get sortByRating => 'التقييم';

  @override
  String get searchProductsHint => 'البحث عن منتجات...';

  @override
  String get searchProduct => 'ابحث عن منتج';

  @override
  String noItemsFound(Object query) {
    return 'لم يتم العثور على نتائج تطابق \"$query\"';
  }

  @override
  String get categories => 'الفئات';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get customerExperience => 'تجربة العملاء';

  @override
  String get newSeasonArrival => 'وصل حديثاً للموسم الجديد';

  @override
  String discountPercent(Object percentage) {
    return 'خصم $percentage%-';
  }

  @override
  String ratingSummary(num count, Object rating) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تقييم',
      many: '$count تقييم',
      few: '$count تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
      zero: 'لا توجد تقييمات',
    );
    return '$rating ($_temp0)';
  }

  @override
  String get productHighlights => 'أبرز مميزات المنتج';

  @override
  String get specifications => 'المواصفات';

  @override
  String get manufacturerInfo => 'معلومات المصنع';

  @override
  String get brand => 'الماركة';

  @override
  String get sku => 'رمز المنتج';

  @override
  String get weight => 'الوزن';

  @override
  String get dimensions => 'الأبعاد';

  @override
  String get availability => 'التوفر';

  @override
  String manufacturerNotice(Object brand, Object sku) {
    return 'تم تصنيع وتوزيع هذا المنتج بواسطة $brand. تم فحص الجودة واعتماده وفقاً لمعايير $sku.';
  }

  @override
  String get myCart => 'سلة التسوق';

  @override
  String get totalPrice => 'إجمالي السعر';

  @override
  String get similarProducts => 'منتجات مشابهة';

  @override
  String get remove => 'إزالة';

  @override
  String get contactInfo => 'معلومات الاتصال';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get careerDetails => 'تفاصيل العمل';

  @override
  String get role => 'الدور';

  @override
  String get jobTitle => 'المسمى الوظيفي';

  @override
  String jobDescription(Object dept, Object title) {
    return '$title في $dept';
  }

  @override
  String get physicalDetails => 'التفاصيل البدنية';

  @override
  String get age => 'العمر';

  @override
  String ageValue(Object count) {
    return '$count سنة';
  }

  @override
  String get bloodGroup => 'فصيلة الدم';

  @override
  String get height => 'الطول';

  @override
  String heightValue(Object value) {
    return '$value سم';
  }

  @override
  String weightValue(Object value) {
    return '$value كجم';
  }

  @override
  String get atmosphereLabel => 'الأجواء';

  @override
  String get atmosphereTitle => 'فن الراحة';

  @override
  String get atmosphereSubtitle => 'إعادة تعريف الهدوء المنزلي.';

  @override
  String get olfactiveLabel => 'الروائح';

  @override
  String get olfactiveTitle => 'روائح فاخرة';

  @override
  String get olfactiveSubtitle => 'بصمات خفية للمنزل.';

  @override
  String get formsLabel => 'الأشكال';

  @override
  String get formsTitle => 'حياة منحوتة';

  @override
  String get formsSubtitle => 'حيث تلتقي الوظيفة بالفن الرفيع.';

  @override
  String get audioLabel => 'الصوت';

  @override
  String get audioTitle => 'مستقبل الصوت';

  @override
  String get audioSubtitle => 'هندسة دقيقة غامرة.';

  @override
  String get newNarratives => 'روايات جديدة';

  @override
  String get editorsChoice => 'اختيار المحرر';

  @override
  String get continueShopping => 'مواصلة التسوق';

  @override
  String get networkErrorTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get networkErrorMessage =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get networkErrorRetry => 'إعادة المحاولة';

  @override
  String get networkErrorDismiss => 'تجاهل';
}
