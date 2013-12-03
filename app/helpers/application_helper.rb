module ApplicationHelper
  def make_json_string_from_errors_hash errors_hash
    string = "{"
    for attribute, problem in errors_hash
      string << "#{attribute.to_s}: #{problem}"
    end
    string << "}"
  end
end
