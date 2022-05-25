require 'base64'

class Api::V1::AuthController < Api::ErrorRenderController
  protect_from_forgery
  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # userid:tokenの形をbase64エンコードする
      auth = Base64.encode64("#{user.id.to_s}:#{User.new_token}")
      # user tableのauth_tokenに入れる（末尾に謎の改行コードが入ってしまうので.chomp!で改行コードを削除）
      user.auth_token = auth.chomp!
      # user tableのexpiration_dateに有効期限（現在時刻から30分後）を入れる
      user.expiration_date = Time.now + 30 * 60
      # DBの変更を保存
      user.save
      render json: { "success": { "auth": auth, "expiration_date": Time.now + 30 * 60 } }
    else
      render json: { "error": { "status": 401, "message": 'Unauthorized' } }
    end
  end
end
