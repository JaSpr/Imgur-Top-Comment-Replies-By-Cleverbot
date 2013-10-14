#require_relative 'lib/imgur'
require_relative 'lib/cleverbot'
require 'imgur'

module CleverBotComments
  class Engine

    def initialize
        @imgur = Imgur::Client.new({config_path: '~/.imgurrc.comments'})
        @cleverbot = Cleverbot::Client.new
        @past_posts = []

        spin_up
    end

    def spin_up

      # Our long-running thread
      Thread.new do
        while true

          begin
            puts 'fetching images...'
            @imgur.refresh_token
            image = @imgur.images.all(resource: 'gallery', section: 'hot', sort: 'time', page: 0).first

            puts "image id: #{image.id}"

            comments = image.comments
            comment = get_latest_unused_comment comments

            if comment
              puts "Comment: #{comment.id} :: #{comment.comment}"
              response = @cleverbot.write comment.comment

              puts "Response: #{response}"
              if response.length > 0
                  reply = comment.reply response
                  puts reply.id
              end
            end
          rescue => e
            puts "EXCEPTION: #{e.message}"
            puts e.backtrace
          end

          @past_posts.push image.id
          @past_posts.push comment.id if comment

          # Randomize your wait time between posts so as not to arouse suspicion!
          delay = rand(180...600)

          puts "sleeping for #{delay} seconds..."
          puts ''

          sleep delay || rand(180...600)
        end
      end
    end

    def get_latest_unused_comment(comments)
      comments.each do |comment|
        unless @past_posts.include? comment.id
          return comment
        end
      end
    end

  end


end