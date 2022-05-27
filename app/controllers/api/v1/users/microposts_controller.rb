module Api
  module V1
    module Users
      class MicropostsController < Api::ErrorRenderController

        def index
          # リクエストヘッダーを取得
          header = request.headers[:Authorization]
          # リクエストヘッダーを探す
          user_token = User.find_by(auth_token:header)
          if user_token != nil
            if Time.now <= user_token.expiration_at.in_time_zone('Tokyo')
              @user = User.find(params[:user_id]) # ユーザーIDの指定
              @page = params[:page] # ページネーションのページの指定。指定がなければ1
              @per_page = params[:per_page] || 30 # マイクロポストの表示数を指定。指定がなければ30
              @microposts = @user.microposts.paginate(page: @page, per_page: @per_page)
              render json: {microposts: @microposts, token: header}
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
