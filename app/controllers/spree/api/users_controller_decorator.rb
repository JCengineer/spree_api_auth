module Spree
  module Api
    module V1

    UsersController.class_eval do
      before_action :authenticate_user, :except => [:sign_up, :sign_in]

      def sign_up

        @user = Spree::User.find_by_email(params[:user][:email])

        if @user.present?
          render "spree/api/users/user_exists", :status => 401 and return
        end

        @user = Spree::User.new(user_params)

        if params[:guest_order_number].present?
          guest_order = Spree::Order.find_by!(number: params[:guest_order_number])

          if guest_order.present?
            @user.orders << guest_order
          end
        end

        if !@user.save
          unauthorized
          return
        end

        @user.generate_spree_api_key!
      end

      def sign_in
        @user = Spree::User.find_by_email(params[:user][:email])
        if !@user.present? || !@user.valid_password?(params[:user][:password])
          unauthorized
          return
        end

        if params[:guest_order_number].present?
          guest_order = Spree::Order.find_by!(number: params[:guest_order_number])

          if guest_order.present?
            guest_order.user_id = @user.id
            guest_order.save
          end
        end

        @user.generate_spree_api_key! if @user.spree_api_key.blank?
      end


      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

    end

    end
  end
end

