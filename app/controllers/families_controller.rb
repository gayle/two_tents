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
    if params[:participant]
      @participant = Participant.find(params[:participant])
      @participant.main_contact = true
    else
      @participant = Participant.new(:main_contact => true)
    end

    @family = Family.new
    @family.participants = [@participant]

    # give some extra blanks
    3.times do
      @family.participants << Participant.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family }
    end
  end

  # GET /families/1/edit
  def edit
    @family = Family.find(params[:id])
    participants = @family.participants.sort_by{|a| a.birthdate}
    @family.participants = move_main_contact_to_front(participants)
    @family.participants << Participant.new

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

    respond_to do |format|

      Family.transaction do
# TODO put if's around this
        participants = []
        # Doesn't seem like I should have to do this.
        # See http://railscasts.com/episodes/75-complex-forms-part-3
        params[:family][:existing_participant_attributes] ||= {}
        params[:family][:existing_participant_attributes].each_key do |k|
          p = Participant.find(k.to_i)
          participants << p if p
        end

        params[:family][:new_participant_attributes] ||= []
        params[:family][:new_participant_attributes].each do |attributes|
          if !attributes_blank?(attributes)
            p = Participant.new(attributes)
            participants << p
          end
        end

        @family.participants = participants
        if @family.save
          AuditTrail.audit("Family #{@family.familyname} created by #{current_user.login}", family_url(@family))

          flash[:notice] = "Family #{@family.familyname} was successfully created."
          format.html { params[:commit] == 'Save' ? redirect_to(families_path) : redirect_to(new_family_path) }
          format.xml  { render :xml => @family, :status => :created, :location => @family }
        else
          puts "UNABLE TO SAVE, #{@family.errors.to_a.join(',')}"
          logger.error ("Unable to save family #{@family.familyname}: #{@family.errors.inspect}")
          flash[:error] = "Unable to save family #{@family.familyname}: #{@family.errors.to_a.join(',')}"
          format.html { render :action => "new" }
          format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    params[:family][:existing_participant_attributes] ||= []
    @family = Family.find(params[:id])
    # !!! I'm not sure why I need to reload here, but if I don't, then the
    # !!! associated .participants are nil.
    @family.reload

    respond_to do |format|
      if @family.update_attributes(params[:family])
        AuditTrail.audit("Family #{@family.familyname} updated by #{current_user.login}", family_url(@family))
        flash[:notice] = 'Families was successfully updated.'
        format.html { redirect_to(families_path) }
        format.xml  { head :ok }
        format.js do
          flash.discard
          render(:update) do |page|
            element = "#{@family.class}_#{@family.id}_#{params[:family].keys[0]}"
            page.replace_html(element,
                              :partial => 'flipflop',
                              :locals => {:family => @family,
                                :type => params[:family].keys[0] } )
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
        message = "Unable to save family #{@family.familyname}: #{@family.errors.to_a.join(',')}"
        flash[:error] = message
        logger.error(message)
        puts(message)
      end
    end
  end

  def update_add_participant
    @participant = Participant.find(params[:participant_id])
    @family = Family.find(params[:family][:id])
    @family.participants ||= []
    @family.participants << @participant
    redirect_to participants_url
  end
  
  def family_registration
    params[:participant].each_pair do |k,v|
      p = Participant.find(k)
      year = Configuration.current.year
      reg = p.registrations.find(:first, :conditions => ["year = ?", year] )
      room = Room.find(v)
      if reg.nil?
        reg = Registration.create(:year => year)
        reg.room = room
        p.registrations << reg
      else
        reg.room = Room.find(v.to_i)
        reg.save
      end
    end
    redirect_to family_url(params[:family][:id])
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
end
