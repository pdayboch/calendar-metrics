class Event

attr_reader :creator, :year, :month, :day, :summary

  def initialize(creator, year, month, day, options = {})
    @creator = creator
    @year = year
    @month = month
    @day = day
    @summary = options[:summary]
  end

end
