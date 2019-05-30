class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :avatar, :avatar_cache, :remove_avatar, :telegram_id, :language) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_cache, :remove_avatar, :telegram_id, :language) }
  end

  private

  def set_locale
    params[:locale] = user_signed_in? ? current_user.language : I18n.default_locale
    I18n.locale = params[:locale]
  end

  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def must_be_admin
    unless (current_user && (current_user.has_role? :admin))
      redirect_to root_path, notice: "Some message"
    end
  end

  def resource_name
    :user
  end
  helper_method :resource_name

  def resource
    @resource ||= User.new
  end
  helper_method :resource

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :devise_mapping

  def resource_class
    User
  end
  helper_method :resource_class

end
