class Notifications
  def self.new_nitpick options
    new options
  end

  private
  def initialize options
    @to = options.fetch(:submitter).email
    @name = options.fetch(:submitter).username
    @from = options.fetch(:nitpick).nitpicker.username
    make_with_the_email
  end

  def make_with_the_email
    Email.new(
      to: @to,
      name: @name,
      subject: subject,
      body: body,
    ).ship
  end

  def subject regarding = "Nitpick"
    "New #{regarding} From #{@from}"
  end

  #TODO erb
  def body
    <<-eos
      Hi #{@name},
      Your submission has recived feedback from #{@from}! Visit exercism.io to find out more.
    eos
  end
end
