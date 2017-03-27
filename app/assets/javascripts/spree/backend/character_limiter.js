CharacterLimiter = function() {
  this.characterLimitSpan = $('span#remaining_character_span');
  this.limitedCharacterInput = $('textarea.character-limited');
  if(this.limitedCharacterInput.length > 0) {
    this.characterLimit = this.limitedCharacterInput.data('characterLimit');
    this.removeDynamicCode = this.limitedCharacterInput.data('removeDynamicCode');
  }
}

CharacterLimiter.prototype.checkCharacterCount = function() {
  var inputValueLength = this.getInputValueLength(this.limitedCharacterInput.val())
  if(inputValueLength > this.characterLimit) {
    if(this.removeDynamicCode){
      this.limitedCharacterInput.val(this.limitedCharacterInput.val().substring(0, this.characterLimit + (this.limitedCharacterInput.val().length - inputValueLength)));
    } else {
      this.limitedCharacterInput.val(this.limitedCharacterInput.val().substring(0, this.characterLimit));
    }
    inputValueLength = this.getInputValueLength(this.limitedCharacterInput.val())
  }
  this.characterLimitSpan.html(this.characterLimit - inputValueLength);
};

CharacterLimiter.prototype.getInputValueLength = function(value) {
  if(this.removeDynamicCode){
    return(value.replace(/<.*?>/g, '').length)
  } else {
    return(value.length)
  }
}

CharacterLimiter.prototype.init = function() {
  var _this = this;
  if(this.limitedCharacterInput.length > 0) {
    this.checkCharacterCount();
    this.limitedCharacterInput.on('input', function() {
      _this.checkCharacterCount();
    })
  }
};

$(function() {
  var characterLimiter = new CharacterLimiter();
  characterLimiter.init();
});