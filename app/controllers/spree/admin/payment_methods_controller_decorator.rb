Spree::Admin::PaymentMethodsController.class_eval do

  def create
    @payment_method = params[:payment_method].delete(:type).constantize.new(payment_method_params)
    @payment_method.create_job_for_marketing = true
    @object = @payment_method
    invoke_callbacks(:create, :before)
    if @payment_method.save
      invoke_callbacks(:create, :after)
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:payment_method))
      redirect_to edit_admin_payment_method_path(@payment_method)
    else
      invoke_callbacks(:create, :fails)
      respond_with(@payment_method)
    end
  end

end
