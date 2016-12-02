Spree::Image.class_eval do
  def get_image_binary
    open(get_image_url)
  end

  private
    def get_image_url
      if self.attachment.options[:storage] == :filesystem
        self.attachment.path
      else
        self.attachment.url
      end
    end
end