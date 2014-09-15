json.array!(@settings) do |setting|
  json.extract! setting, :id, :hours_before_email, :hours_alert, :days_before_reports, :generate_reports, :time_zone
  json.url setting_url(setting, format: :json)
end
