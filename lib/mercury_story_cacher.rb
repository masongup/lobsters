require 'faraday'
require 'json'

class MercuryStoryCacher
  MERCURY_API_KEY = ENV['MERCURY_API_KEY']
  MERCURY_API_URL = 'https://mercury.postlight.com/parser' #?url=

  def self.get_story_text(story)
    # Skip PDFs
    if story.url.to_s.match(/\.pdf$/i)
      return nil
    end

    raw_response = Faraday.get(MERCURY_API_URL, { url: story.url }, { 'x-api-key' => MERCURY_API_KEY })
    return nil if raw_response.status != 200
    json_response = JSON.parse(raw_response.body)
    story_body = json_response['content']
  end
end
