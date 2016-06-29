class CheckstudiesController < ApplicationController
  before_action :set_checkstudy, only: [:show, :edit, :update, :destroy]

  # GET /checkstudies
  # GET /checkstudies.json
  def index
    @checkstudies = Checkstudy.all
  end

  # GET /checkstudies/1
  # GET /checkstudies/1.json
  def show
  end

  def show_check
    @user = User.find(params[:user_id])
    @checkstudies = @user.checkstudy

    @sec = Sec.find(params[:sec_id])
    
    @checkstudies = @checkstudies.where(:sec_id => @sec)
    

    @check = Checkstudy.where(:sec_id => @sec)

    @check_round = @check.max { |a| a.round }
    if @check_round == nil
      @check_round = 0
    else
      @check_round = @check_round.round
    end
    @come_class  = @checkstudies.where(:status => 'come class')
    @come_class  = @come_class.count
    @come_late   = @checkstudies.where(:status => 'come late')
    @come_late   = @come_late.count
    @check_round = @check_round - @come_class - @come_late

    if params[:colum] == 'status'
      @checkstudies = @checkstudies.sort_by{|a| a.status}
    elsif params[:colum] == 'timecheck'
      @checkstudies = @checkstudies.sort_by{|a| a.time_check}
    elsif params[:colum] == 'round'
      @checkstudies = @checkstudies.sort_by{|a| a.round}
    elsif params[:colum] == 'name'
      @checkstudies = @checkstudies.sort_by{|a| a.user.name}
    end
  end

  # GET /checkstudies/new
  def new
    @checkstudy = Checkstudy.new
    @users = User.all
    @subjects = Subject.all
    @secs = Sec.all
  end

  # GET /checkstudies/1/edit
  def edit
    @users = User.all
    @subjects = Subject.all
    @secs = Sec.all
  end

  # POST /checkstudies
  # POST /checkstudies.json
  def create
    @checkstudy = Checkstudy.new(checkstudy_params)
    @user = User.find_by_id(params[:user])
    @checkstudy.user = @user
    @sec = Sec.find_by_id(params[:sec])
    @checkstudy.sec = @sec
    respond_to do |format|
      if @checkstudy.save
        format.html { redirect_to @checkstudy, notice: 'Checkstudy was successfully created.' }
        format.json { render :show, status: :created, location: @checkstudy }
      else
        format.html { render :new }
        format.json { render json: @checkstudy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checkstudies/1
  # PATCH/PUT /checkstudies/1.json
  def update
    @user = User.find_by_id(params[:user])
    @checkactivity.user = @user
    @sec = Sec.find_by_id(params[:sec])
    @activity.sec = @sec
    respond_to do |format|
      if @checkstudy.update(checkstudy_params)
        format.html { redirect_to @checkstudy, notice: 'Checkstudy was successfully updated.' }
        format.json { render :show, status: :ok, location: @checkstudy }
      else
        format.html { render :edit }
        format.json { render json: @checkstudy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkstudies/1
  # DELETE /checkstudies/1.json
  def destroy
    @checkstudy.destroy
    respond_to do |format|
      format.html { redirect_to checkstudies_url, notice: 'Checkstudy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def receiveCheckStudentName
    if params[:menu].to_s != 'activity'
      @checkstudy = Checkstudy.new
      @checkstudy.status = params[:menu]
      timesprit = params[:time_check].split('-')
      timesprit = timesprit[2] + '-' + timesprit[1] + '-' + timesprit[0] + ' ' + timesprit[3] + ':' + timesprit[4] + ':' + timesprit[5]

      @checkstudy.time_check = timesprit

      @checkstudy.round = params[:count]
      @student = Student.find_by_studentid(params[:student_id])
      if @student == nil
        render :text => ''
      else
        @user = @student.user
        if @user == nil
          render :text => ''
        else
          @checkstudy.user = @user
          @subject = Subject.find_by_subject_ID(params[:course_id])
          if @subject == nil
            render :text => ''
          else
            @secs = Sec.where(:subject_id => @subject)
            if @secs.length == 0
              render :text => ''
            else
              @sec = Sec.find_by_sec(params[:section])
              if @sec == nil
                render :text => ''
              else
                @checkstudy.sec = @sec
                @checkstudy.save!
                render :text => ''
              end
            end
          end
        end
      end
    else
      @checkactivity = Checkactivity.newtimesprit = params[:time_check].split('-')
      timesprit = timesprit[2] + '-' + timesprit[1] + '-' + timesprit[0] + ' ' + timesprit[3] + ':' + timesprit[4] + ':' + timesprit[5]

      @checkactivity.time_check = timesprit
      @student = Student.find_by_studentid(params[:student_id])
      @user = @student.user
      if @user == nil
        render :text => ''
      else
        @checkactivity.user = @user
        @subject = Subject.find_by_subject_ID(params[:course_id])
        if @subject == nil
          render :text => ''
        else
          @secs = Sec.where(:subject_id => @subject)
          if @secs.length == 0
            render :text => ''
          else
            @sec = @secs.find_by_sec(params[:section])
            if @sec == nil
              render :text => ''
            else
              @activities = Activity.where(:sec_id => @sec)
              if @activities.length == 0
                render :text => ''
              else
                @activity = @activities.find_by_counts(params[:count])
                if @activity == nil
                  render :text => ''
                else
                  @checkactivity.activity = @activity
                  @checkactivity.save!
                  render :text => ''
                end
              end
            end
          end
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkstudy
      @checkstudy = Checkstudy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkstudy_params
      params.require(:checkstudy).permit(:status, :time_check, :round, :user_id, :sec_id)
    end
end
