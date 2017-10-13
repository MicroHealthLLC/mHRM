require_dependency "mhspreadsheet/application_controller"

module Mhspreadsheet
  class MhSpreadsheetsController < ApplicationController
    before_action  :authenticate_user!
    def index
      @sheet = Mhspreadsheet::MhSpreadsheet.where(user_id: User.current.id).first_or_initialize
    end

    def save
      @sheet = Mhspreadsheet::MhSpreadsheet.where(user_id: User.current.id).first_or_initialize
      @rss.content = params[:content]
      @rss.save
      render json: {success: true}
    end
  end
end