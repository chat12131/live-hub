class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    today = Time.zone.today
    this_month = today.month
    start_of_month = Date.current.beginning_of_month
    start_of_next_month = (Date.current + 1.month).beginning_of_month

    @total_live_records = current_user.live_records.count

    @this_month_live_count = current_user.live_records.where(date: start_of_month..start_of_next_month).count

    @unique_artist_count = current_user.live_records.joins(:artist).distinct.count('artists.id')

    @half_year_live_count = current_user.live_records.where(date: 6.months.ago.beginning_of_day..Time.zone.now.end_of_day).count

    @live_expense = current_user.live_records.sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")

    @goods_expense = current_user.goods.where.not(price: nil).sum('price * quantity')

    live_total = current_user.live_records.sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")
    goods_total = current_user.goods.where.not(price: nil).sum('price * quantity')
    @total_expense = live_total + goods_total

    @this_month_goods_count = current_user.goods.where(date: start_of_month..start_of_next_month).count

    @member_goods_ranking = current_user.goods.joins(:member).group('members.name').sum('goods.price * goods.quantity')

    @top_venues = current_user.live_records.group(:venue_id).order('count_id DESC').limit(3).count(:id)

    @monthly_live_labels = (0..11).to_a.reverse.map do |months_ago|
      l(months_ago.months.ago, format: "%Y年%B")
    end

    @monthly_live_counts = (0..11).to_a.reverse.map do |months_ago|
      month_start = months_ago.months.ago.beginning_of_month
      month_end = months_ago.months.ago.end_of_month
      current_user.live_records.where(date: month_start..month_end).count
    end

    @genre_counts = current_user.live_records.joins(:artist).group('artists.genre').count

    @weekly_live_counts = {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}
    live_counts = current_user.live_records.where(date: 6.months.ago..Time.zone.now).group_by { |record| record.date.wday }.transform_values(&:count)
    @weekly_live_counts.merge!(live_counts)


    @category_expenses = current_user.goods.joins(:category).group('categories.name').sum('goods.price * goods.quantity')
  end
end
