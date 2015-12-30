require "./lib/cal/engine.rb"
require "./lib/cal/calendar.rb"
require 'csv'

class Build
  attr_accessor :calendars

  APPLICATION_NAME = 'MiniLab Metrics Event grabber'
  #CALS_WANTED = ["Cisco Meraki Mini Lab 3","Cisco Meraki Mini Lab 2","Cisco Meraki Mini Lab 1"]
  CALS_WANTED = ["Cisco Meraki Mini Lab 3"]
  START_TIME = Time.new(2014, 12, 1)

  # Obtain a list of calendars within this Google account.
  def download_calendars(apiEngine)
    entries = apiEngine.client.execute(:api_method => apiEngine.api.calendar_list.list)
    @calendars = Hash.new
    entries.data.items.each do |calendar|
      @calendars["#{calendar.summary.chomp}"] = Calendar.new(calendar.id, calendar.summary, :startTime => START_TIME)
    end
    @calendars
  end

  def buildEventsList(calendars)
    csv_array = []
    CALS_WANTED.each do |cal_wanted|
      cal_events = calendars[cal_wanted].events
      cal_events.each do |event|
        temp_array = [cal_wanted, event.creator, event.year, event.month, event.day, event.summary]
        csv_array.push(temp_array)
      end
    end
    csv_array
  end

  def export_csv(rows)
    # Verbose
    puts "Exporting #{csv_array.length} events from #{CAL_NAME_TO_ID.length} calendars."

    # Export events to CSV
    header = ["Calendar Name", "Creator Email", "Month","Day","Year", "Summary"]
    CSV.open("Cal_output", "w") do |csv|
      csv << header
      rows.each do |row|
        csv << row
      end
    end
  end

  def setup()
    # Setup the API and authenticate
    apiEngine = Engine.new(APPLICATION_NAME)

    # Create an array of Calendar objects for cache.
    @calendars = download_calendars(apiEngine)

    # Download the events for specific calendars only.
#    CALS_WANTED.each do |cal_wanted|
#      @calendars[cal_wanted].download_events(apiEngine)
#    end

#    buildEventsList(@calendars).each do |event|
#      puts event
#    end
  end
end

  #events = get_events(CAL_NAME_TO_ID, client, calendar_api)
  #rows = build_events(events)
  #export_csv(rows)
