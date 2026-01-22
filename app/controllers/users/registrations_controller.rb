# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :reject_guest_update, only: [:update, :destroy]












    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end

    def update_resource(resource, params)
      email_changed = params[:email].present? && params[:email] != resource.email
      if email_changed || params[:password].present?
        super
      else
        cleaned_params = params.except("current_password")
        resource.update_without_password(cleaned_params)
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :username])
    end

    def after_update_path_for(_resource)
      mypage_path
    end

    def reject_guest_update
      return unless current_user&.email == "guest@example.com"

      if action_name == "destroy"
        redirect_to mypage_path, alert: "ゲストでは変更は許可されていません"
        return
      end

      return if avatar_only_update?

      redirect_to mypage_path, alert: "ゲストでは変更は許可されていません"
    end

    def avatar_only_update?
      return false unless params[:user].present?

      extra_keys = params[:user].keys.map(&:to_s) - ["avatar"]
      extra_keys.empty?
    end
  end
end
