CharachterLimiter = function(charachterLimitSpan, limitedCharachterInput) {
  this.charachterLimitSpan = $('span#remaining_charachter_span');
  this.limitedCharachterInput = $('textarea.social_media_post_message');
}

CharachterLimiter.prototype.checkCharachterCount = function() { 
  if(this.limitedCharachterInput.val().length > 140) {
    this.limitedCharachterInput.val(this.limitedCharachterInput.val().substring(0, 140));
  }
  this.charachterLimitSpan.html(140 - this.limitedCharachterInput.val().length);
};

CharachterLimiter.prototype.init = function() {
  var _this = this;
  this.checkCharachterCount();
  this.limitedCharachterInput.on('input', function() {
    _this.checkCharachterCount();
  })
};

$(function() {
  var charachterLimiter = new CharachterLimiter($('span#remaining_charachter_span'), $('textarea#social_media_post_post_message'));
  charachterLimiter.init();
});