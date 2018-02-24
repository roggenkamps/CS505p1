json.extract! log, :id, :user, :relation, :operation, :object, :parameters, :created_at, :updated_at
json.url log_url(log, format: :json)
