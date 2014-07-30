json.array!(@time_cards) do |time_card|
  json.extract! time_card, :id, :time_started, :time_stopped, :date, :message
  json.url time_card_url(time_card, format: :json)
end
