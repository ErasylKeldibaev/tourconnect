class AppConfig {
  static const appName = 'TourConnect';
  static const version = '2.0.0';

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://yjgwwviuacwwlcdtpbei.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_YHqcR7GbCAKjWvFjgG5saw_ej5-WVVS',
  );
}
