require_relative 'imgur/base'

class Imgur < ImgurBase

  def get_latest_viral_images
    _get_from_imgur URI("#{@url}3/gallery/hot/time/0?showViral=true")
  end

  def get_best_comments (image)
    _get_from_imgur URI("#{@url}3/gallery/image/#{image['id']}/comments/best")
  end

  def submit_comment(id, comment)
    uri  = URI("#{@url}3/comment")
    data = {
        :image_id => id,
        :comment => comment
    }
    _post_to_imgur uri, data
  end

  def submit_response(image_id, comment_id, reply)
    uri = URI("#{@url}3/gallery/#{image_id}/comment/#{comment_id}")
    data = {
        :image_id => image_id,
        :comment  => reply
    }
    _post_to_imgur uri, data
  end
    
end