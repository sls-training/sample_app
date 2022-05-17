module Api
  module V1
    module Users
      class MicropostsController < Api::ErrorRenderController
        def index
          @user = User.find(params[:user_id]) # ユーザーIDの指定
          @page = params[:page] # ページネーションのページの指定。指定がなければ1
          @per_page = params[:per_page] || 30 # マイクロポストの表示数を指定。指定がなければ30
          @microposts = @user.microposts.paginate(page: @page, per_page: @per_page)
          render json: {microposts: @microposts}
        end
      end
    end
  end
end
