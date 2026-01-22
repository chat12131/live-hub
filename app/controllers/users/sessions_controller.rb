# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :ensure_normal_user, only: :destroy

    def guest_sign_in
      user = User.guest
      sign_in user
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
    end

    def ensure_normal_user
      if resource.email == 'guest@example.com'
        redirect_to root_path, alert: 'ゲストユーザーは削除できません。'
        return
      end
    end





  end
end
