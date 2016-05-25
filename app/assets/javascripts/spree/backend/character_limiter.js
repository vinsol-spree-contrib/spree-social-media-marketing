CharacterLimiter = function() {
  this.characterLimitSpan = $('span#remaining_character_span');
  this.limitedCharacterInput = $('textarea.character-limited');
}

CharacterLimiter.prototype.checkCharacterCount = function() { 
  if(this.limitedCharacterInput.val().length > 140) {
    this.limitedCharacterInput.val(this.limitedCharacterInput.val().substring(0, 140));
  }
  this.characterLimitSpan.html(140 - this.limitedCharacterInput.val().length);
};

CharacterLimiter.prototype.init = function() {
  var _this = this;
  this.checkCharacterCount();
  this.limitedCharacterInput.on('input', function() {
    _this.checkCharacterCount();
  })
};

$(function() {
  var characterLimiter = new CharacterLimiter();
  characterLimiter.init();
});