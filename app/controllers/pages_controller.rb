class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'new_home'
      'new_home'
    else
      'application'
    end
  end
end
