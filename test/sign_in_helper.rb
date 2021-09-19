module SignInHelper
  def sign_in_as(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
        user.provider,
        uid: user.uid,
        info: { nickname: user.name,
                image: user.image_url })
    
    case
    when respond_to?(:visit)
      visit root_path
      click_on "Githubでログイン"
    when 
       respond_to?(:get)
       get "/auth/github/callback"
    else
      raise NotImplementedError.new
    end
    @current_user
  end

  def current_user
    @current_user
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end