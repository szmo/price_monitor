class DealsController < ApplicationController

  before_action :authenticate_user!

  def index
    @deals = current_user.deals
  end

  def search
    deal = BasicParser.new(params[:deal][:url]).parse
    if deal
      deal_from_db = Deal.where(name: deal.name)
      if deal_from_db.empty?
        deal[:scrape_interval] = 60
        deal.save!
        deal_id = deal.id
      else
        deal_id = deal_from_db.first.id
      end
      current_user.user_deals.create!(deal_id: deal_id)
    end
    redirect_to deals_url
  end

  def show
    @deal = Deal.find(params[:id])
  end
end
