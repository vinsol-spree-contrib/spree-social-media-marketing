var PostPreview = function(htmlInfo) {
  this.twitterMessageLength = 280;
  this.$messageContainer = $(htmlInfo.messageContainer);
  this.$fbMessageContainer = $(htmlInfo.fbMessageContainer);
  this.$twitterMessageContainer = $(htmlInfo.twitterMessageContainer);
  this.messageValue = '';
};

PostPreview.prototype.previewFbMessage = function() {
  this.$fbMessageContainer.val(this.messageValue);
};

PostPreview.prototype.truncateMessage = function() {
  return $.trim(this.messageValue).substring(0, this.twitterMessageLength);
};

PostPreview.prototype.previewTwitterMessage = function() {
  this.$twitterMessageContainer.val(this.truncateMessage());
  var characterLimiter = new CharacterLimiter();
  characterLimiter.checkCharacterCount();
};

PostPreview.prototype.onMessageChange = function() {
  this.previewFbMessage();
  this.previewTwitterMessage();
};

PostPreview.prototype.init = function() {
  var _this = this;
  this.$messageContainer.on('change keyup', function() {
    _this.messageValue = $(this).val();
    _this.onMessageChange();
  });
};

$(function() {
  var htmlInfo = {
    messageContainer: $("[data-hook=message]").find('.message'),
    twitterMessageContainer: $("[data-hook=twitter_message]").find('.twitter-message'),
    fbMessageContainer: $("[data-hook=fb_message]").find('.fb-message')
  }
  var postPreview = new PostPreview(htmlInfo);
  postPreview.init();
});
