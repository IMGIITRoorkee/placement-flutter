class EndPoints {

  // static const String HOST = 'http://192.168.121.228:3112';
  static const String HOST = 'http://placementdev.channeli.in';
  static const String RESULTS_HOST = 'http://10.11.0.204';
  static final String WITH_INDEX = 'index.json';

  static final Map<String, String> YEAR = {
    'y' : '/2019',
    'y-1' : '/2018',
    'y-2' : '/2017'
  };

  static const String LOGIN = '/token_auth/obtain_pair/';
  static const String REFRESH = '/token_auth/refresh/';

  static const String APPLICATIONS = '/api/placement_and_internship/applications/';
  static const String PROFILES_CLOSED = '/api/placement_and_internship/profiles/';
  static const String PROFILES_ALL = '/api/placement_and_internship/profiles/not_closed/';
  static final String CANDIDATE = '/api/placement_and_internship/get_or_create_candidate/';
  static final String CANDIDATE_RESUME_LIST = '/api/placement_and_internship/resumes/';
  static final List<String> RESULTS_COMPANY = [
    '/internship/company/',    // for internship
    '/placement/company/',     // for placement
  ];
  static final List<String> RESULTS_BRANCH = [
    '/internship/branch/',    // for internship
    '/placement/branch/',     // for placement
  ];

  // Amidst the Trials on Dathomir
  static const String CALLING_STARSHIPS = 'https://swapi.co/api/starships'; 
}