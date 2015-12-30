class Calendar
require './lib/cal/event.rb'
  attr_accessor :ident, :name, :events

  def initialize(id, commonName, options = {})
    @ident = id
    @name = commonName
    @events = options[:events]
    @earliest = options[:startTime]
    @updated = Date.new
  end

  # Obtain this calendar's events.
  # We don't want to download events from all calendars so we force this
  # method to be called in order to download the events from Google. Saves time.
  def download_events(apiEngine)
    @events = []
    results = []
    results = apiEngine.client.execute!(
      :api_method => apiEngine.api.events.list,
      :parameters => {
        :calendarId => @ident,
        :singleEvents => true,
        :orderBy => 'startTime',
        :timeMin => @earliest.iso8601 })

        results.data.items.each do |event|
          if event.start.date_time
            fulldate = event.start.date_time.strftime("%B, %d, %Y")
            month = fulldate.split(',')[0]
            day = fulldate.split(',')[1]
            year = fulldate.split(',')[2]
          else
            fulldate = event.start.date.to_s
            month = fulldate.split('-')[1].to_i
            month = I18n.t("date.month_names")[month]
            day = fulldate.split('-')[2]
            year = fulldate.split('-')[0]
          end
      @events.push(Event.new(event.creator.email, year, month, day, :summary => event.summary))
    end
  end
end
