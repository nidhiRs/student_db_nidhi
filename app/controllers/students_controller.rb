class StudentsController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :authenticate_user!, only: [:register, :register_student]
  before_action :set_student, only: %i[ show edit update destroy approve_student]
  STUDENT_PER_PAGE = 10

  # GET /students or /students.json
  def index
    @students = Student.joins(:institution)
    if params[:full_name].present? && params[:name].present?
      @students = @students.where('students.full_name LIKE ? AND institutions.name LIKE ?', "%#{params[:full_name]}%","%#{params[:name]}%")
    elsif params[:full_name].present?
      @students = Student.search_by_full_name(params[:full_name])
    elsif params[:name].present?
      @students = @students.where('institution.name LIKE ?', "%#{params[:name]}%")
    end
    @students = @students.order(sort_column + " " + sort_direction)
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def register
    @student = Student.new
  end

  def register_student
    @student = Student.new(student_params)
    @student.pending = true
    if @student.save
      redirect_to register_path
      # format.html { redirect_to @student, notice: "Student was successfully registered." }
      # format.json { render :register, status: :ok, location: @student }
    else
        format.html { render :register, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end  
  end

  def pending_students
    @pending_students = Student.pending_students
  end

  def approve_student
    if @student.update_attributes(pending: false)
      redirect_to pending_students_path
    end
  end

  private

  def sort_column
    ['students.full_name', 'institutions.name'].include?(params[:sort]) ? params[:sort] : "students.full_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:full_name, :address, :email, :mobile, :institution_id)
    end
end
