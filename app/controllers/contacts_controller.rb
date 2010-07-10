class ContactsController < ApplicationController
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        ContactMailer.deliver_contact_email(@contact)
        flash[:notice] = "Thank you for you're interest, we'll get back to you asap!"
        format.html { redirect_to root_path }
      else
        format.html { render :action => "new" }
      end
    end
  end
end
