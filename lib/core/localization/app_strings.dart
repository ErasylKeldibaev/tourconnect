import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/travel_provider.dart';

extension AppStringsContext on BuildContext {
  AppStrings get strings => AppStrings(watch<TravelProvider>().languageCode);
}

class AppStrings {
  final String languageCode;

  const AppStrings(this.languageCode);

  bool get isRu => languageCode == 'ru';

  String get english => 'English';
  String get russian => isRu ? 'Русский' : 'Russian';
  String get language => isRu ? 'Язык' : 'Language';
  String get interfaceLanguage =>
      isRu ? 'Язык приложения' : 'App language';
  String get chooseLanguage =>
      isRu ? 'Выберите язык интерфейса' : 'Choose interface language';
  String get selectedLanguage =>
      isRu ? 'Выбран русский' : 'English selected';

  String get navExplore => isRu ? 'Обзор' : 'Explore';
  String get navMap => isRu ? 'Карта' : 'Map';
  String get navSaved => isRu ? 'Сохранено' : 'Saved';
  String get navProfile => isRu ? 'Профиль' : 'Profile';

  String get onboardingTitle =>
      isRu ? 'Посмотрите поездку до регистрации' : 'See the trip before you sign up';
  String get onboardingBody => isRu
      ? 'Ищите города, карты, туры и планируйте маршрут как гость. Регистрация нужна только когда она действительно полезна.'
      : 'Browse cities, maps, tours and planning tools as a guest. Registration stays optional until it is actually useful.';
  String get onboardingExploreTitle =>
      isRu ? 'Изучайте направления' : 'Explore destinations';
  String get onboardingExploreBody => isRu
      ? 'Смотрите города, достопримечательности, рейтинги и идеи до любых действий.'
      : 'See curated cities, sights, ratings and travel ideas before you do anything else.';
  String get onboardingMapTitle => isRu ? 'Пользуйтесь картой' : 'Use the map';
  String get onboardingMapBody => isRu
      ? 'Открывайте города, фильтруйте места и собирайте маршрут без аккаунта.'
      : 'Open cities, filter places, and build a route visually without creating an account.';
  String get onboardingPlanTitle =>
      isRu ? 'Планируйте когда готовы' : 'Plan when ready';
  String get onboardingPlanBody => isRu
      ? 'Сохраняйте места и собирайте план поездки. Войти можно позже для функций профиля.'
      : 'Save favorite places and assemble a simple trip plan. Sign in only when you need profile features.';
  String get exploreAsGuest => isRu ? 'Смотреть как гость' : 'Explore as guest';
  String get skipIntro => isRu ? 'Пропустить' : 'Skip intro';

  String get searchMapHint => isRu
      ? 'Поиск города, страны или места'
      : 'Search city, country or sight';
  String get clearSearch => isRu ? 'Очистить поиск' : 'Clear search';
  String get sights => isRu ? 'Места' : 'Sights';
  String get hidden => isRu ? 'Скрыто' : 'Hidden';
  String get details => isRu ? 'Детали' : 'Details';
  String get plan => isRu ? 'План' : 'Plan';
  String get route => isRu ? 'Маршрут' : 'Route';
  String get go => isRu ? 'Ехать' : 'Go';
  String get close => isRu ? 'Закрыть' : 'Close';
  String get exploreMap => isRu ? 'Карта' : 'Explore map';
  String get mapQuickStart =>
      isRu ? 'Нажмите город или быстрый старт' : 'Tap a city or choose a quick start';
  String get cities => isRu ? 'Города' : 'Cities';
  String get tours => isRu ? 'Туры' : 'Tours';
  String sightsCount(int count) => isRu ? '$count мест' : '$count sights';

  String get account => isRu ? 'Аккаунт' : 'Account';
  String get support => isRu ? 'Поддержка' : 'Support';
  String get editProfile => isRu ? 'Редактировать профиль' : 'Edit Profile';
  String get notifications => isRu ? 'Уведомления' : 'Notifications';
  String get appearance => isRu ? 'Внешний вид' : 'Appearance';
  String get helpCenter => isRu ? 'Помощь' : 'Help Center';
  String get privacyPolicy => isRu ? 'Политика приватности' : 'Privacy Policy';
  String get aboutApp => isRu ? 'О TourConnect' : 'About TourConnect';
  String get logOut => isRu ? 'Выйти' : 'Log Out';
  String get logoutQuestion => isRu ? 'Выйти?' : 'Log out?';
  String get logoutBody =>
      isRu ? 'Вы сможете войти снова в любое время.' : 'You can sign back in anytime.';
  String get cancel => isRu ? 'Отмена' : 'Cancel';
  String get noEmail => isRu ? 'Нет email' : 'No email';
  String get noPhone => isRu ? 'Нет телефона' : 'No phone';
  String get profileFallbackName =>
      isRu ? 'Пользователь TourConnect' : 'TourConnect User';
  String get bioFallback => isRu
      ? 'Добавьте короткое описание для профиля путешественника.'
      : 'Add a short travel bio to personalize your profile.';
  String get levelExplorer => isRu ? 'Исследователь 5 уровня' : 'Level 5 Explorer';
  String get email => isRu ? 'Email' : 'Email';
  String get phone => isRu ? 'Телефон' : 'Phone';
  String get bio => isRu ? 'О себе' : 'Bio';
  String get trips => isRu ? 'Поездки' : 'Trips';
  String get planned => isRu ? 'В плане' : 'Planned';
  String get saved => isRu ? 'Сохранено' : 'Saved';

  String get guestTitle =>
      isRu ? 'Сначала смотрите. Войти можно позже.' : 'Explore first. Sign in when you need it.';
  String get guestBody => isRu
      ? 'Можно смотреть города, карты, места, туры и строить локальные планы без аккаунта.'
      : 'You can browse cities, maps, places, tours, and build local plans without creating an account.';
  String get guestBenefitProfile =>
      isRu ? 'Сохраните профиль путешественника' : 'Save your travel profile';
  String get guestBenefitProfileBody => isRu
      ? 'Храните данные профиля и будущие синхронизированные избранные места.'
      : 'Keep profile details and future synced favorites.';
  String get guestBenefitSync =>
      isRu ? 'Синхронизация на устройствах' : 'Sync across devices';
  String get guestBenefitSyncBody => isRu
      ? 'Используйте один аккаунт, когда будет включена синхронизация Supabase.'
      : 'Use the same account when Supabase sync is enabled.';
  String get guestBenefitAgency =>
      isRu ? 'Быстрее связывайтесь с агентствами' : 'Contact agencies faster';
  String get guestBenefitAgencyBody => isRu
      ? 'Передавайте контакты только тогда, когда решите бронировать.'
      : 'Share contact details only when you decide to book.';
  String get signIn => isRu ? 'Войти' : 'Sign in';
  String get continueExploring =>
      isRu ? 'Продолжить смотреть' : 'Continue exploring';
}
