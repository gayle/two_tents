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
    main_family_contact = Participant.new(:main_contact => true)
    @family = Family.new
    @family.participants = [main_family_contact]
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
      if @family.save
        AuditTrail.audit("Family #{@family.familyname} created by #{current_user.login}", family_url(@family))

        flash[:notice] = "Family #{@family.familyname} was successfully created."
        format.html { params[:commit] == 'Save' ? redirect_to(families_path) : redirect_to(new_family_path) }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
      else
        logger.error ("Unable to save family #{@family.familyname}")
        flash[:error] = "Unable to save family #{@family.familyname}"
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    params[:family][:participants] ||= []
    @family = Family.find(params[:id])

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
      end
    end
  end

  def update_add_participant
    @participant = params[:participant]
    @family = params[:family]
    @family.participants ||= []
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
