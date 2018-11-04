Oath::Configuration.class_eval do
  def self.custom_no_login_handler
    ->(controller) do
      notice = Oath.config.sign_in_notice
      controller.flash[:error] = notice.call
      controller.redirect_to Oath.config.no_login_redirect
    end
  end
end

Oath.configure do |config|
  config.no_login_handler = Oath::Configuration.custom_no_login_handler
end
