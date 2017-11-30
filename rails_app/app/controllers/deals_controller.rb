# frozen_string_literal: true

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
    @adapter = GraphiteAdapter.new
    deal_identifier = @deal.name.parameterize
    filtered_data = filter_data(@adapter.get_metric_json("price_monitor_internal.deals.#{deal_identifier}.price"))
    labels, data = prepare_data_for_chart(filtered_data)

    @data = {
      labels:   labels,
      datasets: [
        {
          label:           @deal.name,
          backgroundColor: 'rgba(151,187,205,0.2)',
          borderColor:     'rgba(151,187,205,1)',
          data:            data,
        },
      ],
    }
    @options = { height: 200 }
  end

  private

  def filter_data(data)
    filtered = []
    data.each do |data|
      filtered.append(data) if data[0].present?
    end
    filtered
  end

  def prepare_data_for_chart(data)
    labels = []
    values = []
    data.each do |arr|
      values.append(arr[0])
      labels.append("#{Time.at(arr[1]).strftime('%Y-%m-%d')} #{Time.at(arr[1]).strftime('%H:%M')}")
    end
    [labels, values]
  end

end
