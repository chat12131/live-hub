class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    today = Time.zone.today
    year_range = today.beginning_of_year..today.end_of_year

    @year_live_count = current_user.live_records.where(date: year_range).count
    @year_live_expense = current_user.live_records.where(date: year_range)
                                         .sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")

    top_venue = current_user.live_records.where(date: year_range)
                          .group(:venue_id)
                          .order('count_id DESC')
                          .limit(1)
                          .count(:id)
                          .first
    if top_venue
      venue = Venue.find_by(id: top_venue[0])
      @year_top_venue_name = venue&.name
      @year_top_venue_count = top_venue[1]
    end

    @year_goods_count = current_user.goods.where(date: year_range).count
    @year_goods_expense = current_user.goods.where(date: year_range).where.not(price: nil).sum('price * quantity')

    top_category = current_user.goods.where(date: year_range)
                          .joins(:category)
                          .group('categories.name')
                          .sum('goods.quantity')
                          .max_by { |_, total| total }
    if top_category
      @year_top_category_name = top_category[0]
      @year_top_category_total = top_category[1]
    end

    @artists_total_count = current_user.artists.count
    @artists_year_count = current_user.artists.where(created_at: year_range).count
    @artists_favorite_count = current_user.artists.where(favorited: true).count

    first_live_date = current_user.live_records.minimum(:date)
    first_goods_date = current_user.goods.minimum(:date)
    first_artist_date = current_user.artists.minimum(:created_at)&.to_date
    first_activity_date = [first_live_date, first_goods_date, first_artist_date].compact.min
    if first_activity_date
      @account_days = (today - first_activity_date).to_i + 1
    end

    @account_actions_year = @year_live_count + @year_goods_count + @artists_year_count
    @account_first_activity_date = first_activity_date
  end

  def live
    today = Time.zone.today
    start_of_month = today.beginning_of_month
    end_of_month = today.end_of_month
    start_of_next_month = (today + 1.month).beginning_of_month
    year_range = today.beginning_of_year..today.end_of_year
    prev_month_date = today - 1.month
    prev_month_range = prev_month_date.beginning_of_month..prev_month_date.end_of_month

    @total_live_records = current_user.live_records.count
    @this_month_live_count = current_user.live_records.where(date: start_of_month..start_of_next_month).count
    @unique_artist_count = current_user.live_records.joins(:artist).distinct.count('artists.id')
    @half_year_live_count = current_user.live_records.where(date: 6.months.ago.beginning_of_day..Time.zone.now.end_of_day).count
    @live_expense = current_user.live_records.sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")

    live_year_scope = current_user.live_records.where(date: year_range)
    live_month_scope = current_user.live_records.where(date: start_of_month..end_of_month)
    prev_month_live_count = current_user.live_records.where(date: prev_month_range).count

    @year_live_expense = live_year_scope.sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")
    @month_live_expense = live_month_scope.sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")
    @year_live_count = live_year_scope.count
    @month_live_count = live_month_scope.count
    @avg_live_expense = @year_live_count.positive? ? (@year_live_expense.to_f / @year_live_count).round : nil
    @month_live_days = live_month_scope.select(:date).distinct.count

    monthly_counts = live_year_scope.group("DATE_FORMAT(date, '%Y-%m')").count
    peak_month = monthly_counts.max_by { |_, count| count }
    if peak_month
      peak_month_date = Date.strptime(peak_month[0], "%Y-%m")
      @peak_month_label = peak_month_date.strftime("%Y年%-m月")
      @peak_month_count = peak_month[1]
    end

    weekend_count = live_year_scope.where("WEEKDAY(date) >= 5").count
    weekday_count = live_year_scope.where("WEEKDAY(date) < 5").count
    total_weekday_weekend = weekend_count + weekday_count
    if total_weekday_weekend.positive?
      @weekend_rate = ((weekend_count.to_f / total_weekday_weekend) * 100).round(1)
      @weekend_count = weekend_count
      @weekday_count = weekday_count
    end

    last_live_date = current_user.live_records.maximum(:date)
    @days_since_last_live = last_live_date ? (today - last_live_date).to_i : nil

    streak = 0
    cursor = Date.new(today.year, today.month, 1)
    loop do
      range = cursor.beginning_of_month..cursor.end_of_month
      count = current_user.live_records.where(date: range).count
      break if count.zero?
      streak += 1
      cursor = cursor.prev_month
    end
    @monthly_live_streak = streak

    first_artist_dates = current_user.live_records.where.not(artist_id: nil).group(:artist_id).minimum(:date)
    @year_new_artist_count = first_artist_dates.values.count { |date| date && date.between?(year_range.first, year_range.last) }

    first_venue_dates = current_user.live_records.where.not(venue_id: nil).group(:venue_id).minimum(:date)
    @year_new_venue_count = first_venue_dates.values.count { |date| date && date.between?(year_range.first, year_range.last) }

    @month_over_month_delta = @month_live_count - prev_month_live_count
    @month_over_month_rate = prev_month_live_count.positive? ? ((@month_over_month_delta.to_f / prev_month_live_count) * 100).round(1) : nil

    last_three_months = (0..2).map { |i| (today - i.months).beginning_of_month..(today - i.months).end_of_month }
    last_three_total = last_three_months.sum { |range| current_user.live_records.where(date: range).count }
    @three_month_avg = (last_three_total.to_f / 3).round(1)

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
    live_counts = current_user.live_records.where(date: 6.months.ago..Time.zone.now)
                      .group_by { |record| record.date.wday }
                      .transform_values(&:count)
    @weekly_live_counts.merge!(live_counts)
  end

  def goods
    today = Time.zone.today
    start_of_month = today.beginning_of_month
    end_of_month = today.end_of_month
    start_of_next_month = (today + 1.month).beginning_of_month
    year_range = today.beginning_of_year..today.end_of_year

    goods_with_price = current_user.goods.where.not(price: nil)
    @goods_expense = goods_with_price.sum('price * quantity')
    @this_month_goods_count = current_user.goods.where(date: start_of_month..start_of_next_month).count
    @member_goods_ranking = current_user.goods.joins(:member).group('members.name').sum('goods.price * goods.quantity')
    @category_expenses = goods_with_price.joins(:category).group('categories.name').sum('goods.price * goods.quantity')
    @category_quantities = current_user.goods.joins(:category).group('categories.name').sum('goods.quantity')

    month_category = current_user.goods.where(date: start_of_month..end_of_month)
                           .joins(:category)
                           .group('categories.name')
                           .sum('goods.quantity')
                           .max_by { |_, total| total }
    if month_category
      @month_top_category_name = month_category[0]
      @month_top_category_count = month_category[1]
    end

    year_category = current_user.goods.where(date: year_range)
                          .joins(:category)
                          .group('categories.name')
                          .sum('goods.quantity')
                          .max_by { |_, total| total }
    if year_category
      @year_top_category_name = year_category[0]
      @year_top_category_count = year_category[1]
    end

    top_month = goods_with_price.where(date: year_range)
                  .group("DATE_FORMAT(date, '%Y-%m')")
                  .sum('goods.price * goods.quantity')
                  .max_by { |_, total| total }
    if top_month
      @top_expense_month_label = top_month[0]
      @top_expense_month_total = top_month[1]
    end
  end

  def artists
    today = Time.zone.today
    year_range = today.beginning_of_year..today.end_of_year

    @artists_total_count = current_user.artists.count
    @artists_year_count = current_user.artists.where(created_at: year_range).count
    @artists_favorite_count = current_user.artists.where(favorited: true).count

    artist_counts = current_user.live_records.joins(:artist)
                      .group('artists.id', 'artists.name')
                      .count
    artist_expenses = current_user.live_records.joins(:artist)
                        .group('artists.id', 'artists.name')
                        .sum("COALESCE(ticket_price, 0) + COALESCE(drink_price, 0)")
    artist_last_dates = current_user.live_records.joins(:artist)
                          .group('artists.id', 'artists.name')
                          .maximum(:date)

    @artist_attendance_labels = artist_counts.sort_by { |_, count| -count }.map { |(id, name), _| name }
    @artist_attendance_values = artist_counts.sort_by { |_, count| -count }.map { |_, count| count }

    @artist_expense_ranking = artist_expenses.sort_by { |_, total| -total }.first(5).map do |(id, name), total|
      count = artist_counts[[id, name]] || 0
      avg = count.positive? ? (total.to_f / count).round : 0
      { name: name, total: total, avg: avg, count: count }
    end

    @artist_recent_ranking = artist_last_dates.sort_by { |_, date| date ? -date.to_time.to_i : 0 }.first(5).map do |(id, name), date|
      { name: name, date: date }
    end

    @artist_away_ranking = artist_last_dates.sort_by { |_, date| date ? date.to_time.to_i : Float::INFINITY }.first(5).map do |(id, name), date|
      { name: name, date: date }
    end

    recent_range = (today - 2.months).beginning_of_month..today.end_of_month
    previous_range = (today - 5.months).beginning_of_month..(today - 3.months).end_of_month
    recent_counts = current_user.live_records.where(date: recent_range)
                      .joins(:artist)
                      .group('artists.id', 'artists.name')
                      .count
    previous_counts = current_user.live_records.where(date: previous_range)
                        .joins(:artist)
                        .group('artists.id', 'artists.name')
                        .count
    deltas = {}
    recent_counts.each do |key, count|
      deltas[key] = count - (previous_counts[key] || 0)
    end
    @artist_trending = deltas.sort_by { |_, delta| -delta }.first(5).map do |(id, name), delta|
      { name: name, delta: delta }
    end
  end
end
