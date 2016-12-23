Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '763791563268-9oj683fv2irfcc6qhsh9nhsnchq61ie3.apps.googleusercontent.com', 'doQeQAB_1Eydt6fOqwrVbovW', scope: 'userinfo.profile,youtube'
end
