class Api::ErrorRenderController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :status_404

  private

  def status_404(_error)
    render json: { "error": { "status": 404, "message": 'not found' } }
  end
end
