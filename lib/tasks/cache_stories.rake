EMAIL_WIDTH = 72
LAST_STORY_CACHE_KEY = "story_cache:last_story_id"
LAST_COMMENT_KEY = "mailing:last_comment_id"

namespace :talkright do
  desc 'Cache body of new stories'
  task :cache_stories => :environment do
    last_story_id = (Keystore.value_for(LAST_STORY_CACHE_KEY) || Story.last.id).to_i
    story_count = 0
    Story.where("id > ? AND is_expired = ?", last_story_id, false).order(:id).each do |s|
      s.fetch_story_cache!
      s.save
      last_story_id = s.id
      story_count += 1
    end
    Rails.logger.info "Cached #{story_count} stories" if story_count > 0
    Keystore.put(LAST_STORY_CACHE_KEY, last_story_id)
  end
end
