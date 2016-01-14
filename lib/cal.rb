require "./lib/cal/engine.rb"
require "./lib/cal/calendar.rb"

class Build
  attr_accessor :calendars, :userCount, :months, :creators, :creatorEventCount

  # Obtain a list of calendars within this Google account.
  private
  def download_calendars(apiEngine)
    entries = apiEngine.client.execute(:api_method => apiEngine.api.calendar_list.list)
    @calendars = []
    entries.data.items.each do |calendar|
      name = calendar.summary.chomp
      @calendars.push(Calendar.new(calendar.id, name,
      :startTime => @dateMin, :endTime => @dateMax))
    end
    @calendars.sort! { |a, b| a.name <=> b.name }
  end

  # populate the creator and month hash for metrics
  # @param calendars [hash{name[string],calendar[Calendar]}] The full list of calendars
  # @param sortByCreator [Boolean] true if sorting by creator name, false if sorting by event count
  # @param asc [Boolean] true if sort acsending, false if sort descending
  def buildMetrics(calendars, sortByCreator, asc)
    @creators = Hash.new()

    @months = buildMonthHash
    calendars.each do |cal|
      if cal.events
        #puts "creating list for: #{cal.name}"
        cal_events = cal.events
        cal_events.each do |event|
          # Creator to event count
          if creators.has_key?(event.creator)
            creators[event.creator].push(event)
          else
            creators[event.creator] = [event]
          end
          # Month to event count
          @months[event.month].push(event)
        end # each even in a calendar
      end # each calendar
    end # calendar has events?

    # sort the creator list
    @creatorEventCount = []
    @creators.each do |name, events|
      @creatorEventCount.push([name, events.count])
    end

    if sortByCreator== "true"
      if asc=="true"
        @creatorEventCount.sort! { |a, b| a[0] <=> b[0] }
      else
        @creatorEventCount.sort! { |a, b| b[0] <=> a[0] }
      end
    else # sort by event count
      if asc =="true"
        @creatorEventCount.sort! { |a, b| a[1] <=> b[1] }
      else
        @creatorEventCount.sort! { |a, b| b[1] <=> a[1] }
      end
    end
  end

  def buildMonthHash()
    monthsHash = Hash.new
    I18n.t("date.month_names").each do |month|
      monthsHash[month] = [] if month
    end
    monthsHash
  end

  def initialize(calsWanted, dateMin, dateMax, sortByCreator = false, asc = false)
    @calsWanted = calsWanted
    @dateMin = dateMin
    @dateMax = dateMax

    # Setup the API and authenticate
    apiEngine = Engine.new

    # Create an array of Calendar objects for cache.
    @calendars = download_calendars(apiEngine)

    # Download the events for specific calendars only.
    @calendars.each do |cal|
      if @calsWanted.include?(cal.name)
        cal.download_events(apiEngine)
      end
    end

    buildMetrics(@calendars, sortByCreator, asc)
  end

end
