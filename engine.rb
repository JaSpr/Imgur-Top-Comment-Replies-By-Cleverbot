require_relative 'lib/imgur'
require_relative 'lib/cleverbot'

module CleverBotComments
  class Engine

    def initialize
        @imgur = Imgur.new
        @cleverbot = Cleverbot::Client.new
        @past_posts = []

        spin_up
    end

    # Our long-running thread
    def spin_up

      Thread.new do
        while true

          begin
            puts 'fetching images...'
            image = get_new_image

            puts "image id: #{image['id']}"

            comment = get_best_comment image
            puts comment
            puts "comment id: #{comment['id']}"

            if comment
              puts "Comment:  #{comment['comment']}"
              response = @cleverbot.write comment['comment']

              puts "Response: #{response}"
              if response.length > 0
                  puts @imgur.submit_response image['id'], comment['id'], response
              end
              puts ''
            end
          rescue => e
            puts "EXCEPTION: #{e.message}"
            puts e.backtrace
          end

          @past_posts.push image['id']
          @past_posts.push comment['id']

          # Randomize your wait time between posts so as not to arouse suspicion!
          sleep_time = rand(180...600)

          puts "sleeping for #{sleep_time} seconds..."
          puts ''

          sleep sleep_time || rand(180...600)
        end
      end
    end

    def get_best_comment(image)
      comments = @imgur.get_best_comments image

      if comments.eql? false
        return false
      end

      comments.each do |comment|
        unless @past_posts.include? comment['id']
          return comment
        end
      end

      false
    end

    def get_new_image
      images = @imgur.get_latest_viral_images

      if images.eql? false
          return false
      end

      images.first
    end
  end
end