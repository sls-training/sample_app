module Api
  module V1
    module Users
      class MicropostsController < Api::ErrorRenderController
        def index
          # リクエストヘッダーを取得
          auth_token = request.headers[:Authorization]
          # リクエストヘッダーを探す
          login_user = User.find_by(auth_token:auth_token)
          if login_user != nil
            if Time.current <= login_user.expiration_at
              @user = User.find(params[:user_id]) # ユーザーIDの指定
              @page = params[:page] # ページネーションのページの指定。指定がなければ1
              @per_page = params[:per_page] || 30 # マイクロポストの表示数を指定。指定がなければ30
              @microposts = @user.microposts.paginate(page: @page, per_page: @per_page)
              render json: {microposts: @microposts}
            else
              render status: 401, json: { error: { status: 401, message: '有効期限が切れています' } }
            end
          else
            render status: 401, json: { error: { status: 401, message: 'トークンが存在しません' } }
          end
        end
      end
    end
  end
end
