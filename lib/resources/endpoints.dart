class EndPoints {
  // static const String HOST = 'http://192.168.121.228:3112';
  static const String HOST = 'https://channeli.in';
  static const String RESULTS_HOST = 'https://results.channeli.in';
  static final String WITH_INDEX = 'index.json';

  static String year(int i) {
    DateTime today = DateTime.now();
    int currentYr = today.year;
    if (today.month < 7) currentYr--;
    return '/' + (currentYr - i).toString();
  }

  static const String LOGIN = '/token_auth/obtain_pair/';
  static const String REFRESH = '/token_auth/refresh/';

  static const FORGOT_PASS = '/auth/forgot_password';

  static const String APPLICATIONS =
      '/api/placement_and_internship/applications/';
  static const String PROFILES_ALL = '/api/placement_and_internship/profiles/';
  static const String PROFILES_APPLIED =
      '/api/placement_and_internship/profiles/applied/';
  static const String PROFILES_ME =
      '/api/placement_and_internship/profiles/not_closed/';
  static final String CANDIDATE =
      '/api/placement_and_internship/get_or_create_candidate/';
  static final String WHOAMI = '/kernel/who_am_i/';
  static final String CANDIDATE_RESUME_LIST =
      '/api/placement_and_internship/resumes/';
  static final String RESUME_DETAIL =
      '/api/placement_and_internship/generate_resume/';
  static final String CALENDAR_EVENTS =
      '/api/placement_and_internship/calendar/';
  static final List<String> RESULTS_COMPANY = [
    '/placement/company/', // for placement
    '/internship/company/', // for internship
  ];
  static final List<String> RESULTS_BRANCH = [
    '/placement/branch/', // for placement
    '/internship/branch/', // for internship
  ];

  // Amidst the Trials on Dathomir
  static const String CALLING_STARSHIPS = 'https://swapi.co/api/starships';
}
