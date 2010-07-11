class FamiliesController < ApplicationController
  include FamiliesHelper # I shouldn't have to do this? 
  
  before_filter :login_required

  # GET /families
  # GET /families.xml
  def index
    @families = Family.paginate :all, :page => params[:page], :order => "familyname ASC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @families }
    end
  end

  # GET /families/1
  # GET /families/1.xml
  def show
    @family = Family.find(params[:id])
    @participants = @family.participants

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family }
    end
  end

  # GET /families/new
  # GET /families/new.xml
  def new
    @family = Family.new
    
    if params[:participant]
      @participant = Participant.find(params[:participant])
      @family.participants << @participant
    else
      @participant = @family.participants.build
    end

    # give some extra blanks
    3.times do
      @family.participants.build
    end
    
    @participants = @family.participants
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family }
    end
  end

  # GET /families/1/edit
  def edit
    @family = Family.find(params[:id])
    @participants = sorted_participants
    # This should go away replaced w/Ajax call to create new participant
    @participants << @family.participants.build
  end

  def edit_choose_family
    @participant = Participant.find(params[:participant])
    @families = Family.find(:all).sort_by { |f|
      f.familyname
    }
  end
  
  # POST /families
  # POST /families.xml
  def create
    @family = Family.new(params[:family])
    @participants = []

    respond_to do |format|
      Family.transaction do
        # Doesn't seem like I should have to do this.
        # See http://railscasts.com/episodes/75-complex-forms-part-3
        params[:family][:existing_participant_attributes] ||= {}
        params[:family][:existing_participant_attributes].each_key do |k|
          p = Participant.find(k.to_i)
          @participants << p if p
        end

        params[:family][:new_participant_attributes] ||= []
        params[:family][:new_participant_attributes].each do |attributes|
          if !attributes_blank?(attributes)
            p = Participant.new(attributes)
            @participants << p
          end
        end

        @family.participants = @participants
        ret = @family.save
        ret2 = nil
        if ret
          @family.main_contact_id = @family.participants[0].id
          ret2 = @family.save
        end
        if ret && ret2
          AuditTrail.audit("Family #{@family.familyname} created by #{current_user.login}", edit_family_path(@family))

          flash[:notice] = "Family #{@family.familyname} was successfully created."
          format.html { params[:commit] == 'Save' ? redirect_to(families_path) : redirect_to(new_family_path) }
          format.xml  { render :xml => @family, :status => :created, :location => @family }
        else
          format.html { render_showing_errors(:action => :new) }
        end          
      end
    end
  rescue Exception => e
    render_showing_errors(:action => :new)
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    params[:family][:existing_participant_attributes] ||= []
    @family = Family.find(params[:id])
    # !!! I'm not sure why I need to reload here, but if I don't, then the
    # !!! associated .participants are nil.
    @family.reload
    @participants = @family.participants
    
    respond_to do |format|
      if @family.update_attributes(params[:family])
        AuditTrail.audit("Family #{@family.familyname} updated by #{current_user.login}", edit_family_path(@family))
        flash[:notice] = "Family #{@family.familyname} was successfully updated."
        format.html { redirect_to(families_path) }
        format.xml  { head :ok }
      else
<<<<<<< HEAD:app/controllers/families_controller.rb
        message = error_saving(@family)
        flash.now[:error] = "#{message}<br />[TECHNICAL DETAILS: update(), update_attributes failed(): #{@family.errors.to_a.join(',')}]"
        logger.error "ERROR #{message} \n#{@family.inspect}}"
        logger.error e.backtrace.join("\n\t")
        render :action => "edit"
=======
        format.html { render_showing_errors(:action => :edit) }
>>>>>>> 1f2a8db8976f983557b59b5cbdda6bda9e0cd8f3:app/controllers/families_controller.rb
      end
    end
  rescue Exception => e
<<<<<<< HEAD:app/controllers/families_controller.rb
    message = error_saving(@family)
    flash.now[:error] = "#{message}<br />[TECHNICAL DETAILS: #{e.message}]"
    logger.error "ERROR #{message} \n#{@family.inspect}}"
    logger.error e.backtrace.join("\n\t")
    render :action => "edit"
=======
    render_showing_errors :action => "edit", :exception => e
>>>>>>> 1f2a8db8976f983557b59b5cbdda6bda9e0cd8f3:app/controllers/families_controller.rb
  end

  def update_add_participant
    @participant = Participant.find(params[:participant_id])
    @family = Family.find(params[:family][:id])
    @family.participants ||= []
    @family.participants << @participant
    redirect_to participants_url
  rescue Exception => e
    render_showing_errors(:action => :edit_choose_family, :exception => e)
  end
  
  # DELETE /families/1
  # DELETE /families/1.xml
  def destroy
    @family = Family.find(params[:id])
    family_name = @family.familyname
    @family.destroy

    AuditTrail.audit("Family #{family_name} deleted by #{current_user.login}")
    flash[:notice] = "Family #{family_name} deleted"
    respond_to do |format|
      format.html { redirect_to(families_url) }
      format.xml  { head :ok }
    end
  end

  private

  def render_showing_errors(params)
    general_message   = error_saving(@family)
    exception_message = got_exception(params[:exception])
    validation_errors = error_list_for(@family)

    flash[:error] = flash_message_for(general_message, exception_message, validation_errors)
    logger.error "#{general_message}\n ERRORS: #{validation_errors.inspect}] \n BACKTRACE:"
    logger.error "EXCEPTION: #{exception_message}\n BACTRACE: #{params[:exception].backtrace.join("\n\t")}" if params[:exception]

    render :action => params[:action]
  end

  def error_saving(family)
    "There was a problem saving the family '#{family.familyname}'"
  end
  
  def got_exception(exception)
    msg = ""
    if exception
      msg << "<br />#{exception.class} Exception: #{exception.message}"
      msg << "<br />#{exception.backtrace[0]}"
      msg << "<br />#{exception.backtrace[1]}"
# TODO maybe keep printing stack until we know it's a line number for app code, not just rails code
#      msg << "<br />#{exception.backtrace[2]}"
#      msg << "<br />#{exception.backtrace[3]}"
#      msg << "<br />#{exception.backtrace[4]}"
#      msg << "<br />#{exception.backtrace[5]}"
#      msg << "<br />#{exception.backtrace[6]}"
    end
    msg
  end

  def error_list_for(family)
    family.errors ? family.errors.to_a.join(', ') : ""
  end

  def flash_message_for(general_message, exception_message, validation_errors)
    msg = "#{general_message}"
    # if validation error, let the validation stuff do it's thing. If not, put more info into the flash.
    if validation_errors.empty?
     msg << "<br />[TECHNICAL DETAILS: #{exception_message} <br />#{validation_errors}]"
    end
    msg
  end
end
