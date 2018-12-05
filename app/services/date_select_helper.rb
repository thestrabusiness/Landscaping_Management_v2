class DateSelectHelper
  attr_reader :params, :field_name, :variable_name
  def initialize(params, variable_name, field_name)
    @params = params
    @variable_name = variable_name
    @field_name = field_name
  end

  def join
    date_params.join('-')
  end

  def all_present?
    params[variable_name].present? && date_params.all?(&:present?)
  end

  def parse(default_date)
    all_present? ? Date.parse(join) : default_date
  end

  private

  def date_params
    return [] if params[variable_name].nil?

    [
        params[variable_name]["#{field_name}(1i)"],
        params[variable_name]["#{field_name}(2i)"],
        params[variable_name]["#{field_name}(3i)"]
    ]
  end
end
