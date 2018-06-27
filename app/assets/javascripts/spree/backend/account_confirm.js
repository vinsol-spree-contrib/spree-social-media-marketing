var AccountConfirm = function(htmlInfo) {
  this.$fbAccounts = $(htmlInfo.fbAccounts);
  this.$twitterAccounts = $(htmlInfo.twitterAccounts);
  this.$fbContainer = $(htmlInfo.fbContainer);
  this.$twitterContainer = $(htmlInfo.twitterContainer);
  this.$modalButton = $(htmlInfo.modalButton);
  this.$submitButton = $(htmlInfo.submitButton);
  this.$errorMessage = $(htmlInfo.errorMessage);
  this.$confirmMesage = $(htmlInfo.confirmMesage);
};

AccountConfirm.prototype.appendNames = function(container, names, msg) {
  container.html(msg + names);
};

AccountConfirm.prototype.fetchNames = function(account) {
  var names = [];
  $.each(account, function(index, elem) {
    $elem = $(elem);
    if($elem.prop('checked')) {
      names.push($elem.data('name'));
    }
  });
  return names;
};

AccountConfirm.prototype.fetchAndAppendAccountNames = function(account, account_container, msg) {
  var names = this.fetchNames(account);
  if(names.length == 0) {
    this.appendNames(account_container, names, '')
  } else {
    this.$submitButton.show();
    this.$errorMessage.hide();
    this.$confirmMesage.show();
    $('[data-type=message]').html('Post will be posted on the following accounts:-');
    this.appendNames(account_container, names, msg)
  };
};

AccountConfirm.prototype.populateAccountsContainer = function() {
  this.fetchAndAppendAccountNames(this.$fbAccounts, this.$fbContainer, 'Facebook - ');
  this.fetchAndAppendAccountNames(this.$twitterAccounts, this.$twitterContainer, 'Twitter - ');
};

AccountConfirm.prototype.addErrorMessage = function() {
  this.$confirmMesage.hide();
  this.$errorMessage.show();
  this.$submitButton.hide();
};

AccountConfirm.prototype.checkAccountSelected = function() {
  var fbNames = this.fetchNames(this.$fbAccounts);
  var twitterNames = this.fetchNames(this.twitterAccounts);
  if($.merge(fbNames, twitterNames).length == 0) {
    this.addErrorMessage();
  }
};

AccountConfirm.prototype.init = function() {
  var _this = this;
  this.$modalButton.on('click', function() {
    _this.checkAccountSelected();
    _this.populateAccountsContainer();
  });
};

$(function() {
  var htmlInfo = {
    fbAccounts: $("[data-type=fb-account]"),
    twitterAccounts: $("[data-type=twitter-account]"),
    fbContainer: $("[data-container=fb_accounts]"),
    twitterContainer: $("[data-container=twitter_accounts]"),
    modalButton: $("[data-type=confirm-modal]"),
    submitButton: $('[data-type=form-button]'),
    errorMessage: $('[data-type=error-message]'),
    confirmMesage: $('[data-type=confirm-message]')
  }
  var accountConfirm = new AccountConfirm(htmlInfo);
  accountConfirm.init();
});
