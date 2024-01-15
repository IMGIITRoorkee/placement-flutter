class FetchedResources {
  static final FetchedResources _fetchedResources = FetchedResources.internal();
  factory FetchedResources() => _fetchedResources;

  Map<String, dynamic> _resultsBranchWise = {
    'initialised': false,
    'data': null
  };
  get resultsBranchWise => _resultsBranchWise;

  Map<String, dynamic> _resultsCompanyWise = {
    'initialised': false,
    'data': null
  };
  get resultsCompanyWise => _resultsCompanyWise;

  Map<String, dynamic> _applyForAll = {'initialised': false, 'data': null};
  get applyForAll => _applyForAll;

  Map<String, dynamic> _applyForMe = {'initialised': false, 'data': null};
  get applyForMe => _applyForMe;

  Map<String, dynamic> _candidateProfile = {'initialised': false, 'data': null};
  get candidateProfile => _candidateProfile;

  FetchedResources.internal() {
    initState();
  }

  void initState() {
    _resultsBranchWise = {'initialised': false, 'data': null};
    _resultsCompanyWise = {'initialised': false, 'data': null};
    _applyForMe = {'initialised': false, 'data': null};
    _applyForAll = {'initialised': false, 'data': null};
    _candidateProfile = {'initialised': false, 'data': null};
  }

  void setResultsBranchWise(results) {
    _resultsBranchWise['initialised'] = true;
    _resultsBranchWise['data'] = results;
  }

  void setResultsCompanyWise(results) {
    _resultsCompanyWise['initialised'] = true;
    _resultsCompanyWise['data'] = results;
  }

  void setApplyForMe(results) {
    _applyForMe['initialised'] = true;
    _applyForMe['data'] = results;
  }

  void setApplyForAll(results) {
    _applyForAll['initialised'] = true;
    _applyForAll['data'] = results;
  }

  void setCandidateProfile(results) {
    _candidateProfile['initialised'] = true;
    _candidateProfile['data'] = results;
  }
}
