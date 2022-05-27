class Api::ErrorRenderController < ApplicationController
  # DBからデータを取得するときに、存在しないデータだった場合
  rescue_from ActiveRecord::RecordNotFound, with: :status_404

  private

  def status_404(_error)
    render status: 404, json: { error: { status: 404, message: 'not found' } }
  end
end
