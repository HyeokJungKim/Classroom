class ClassroomsController < ApplicationController

  def assignments
    @classroom = Classroom.find(params[:id])
    @assignment = Assignment.new(description: params[:description], classroom: @classroom)
    if(@assignment.save)
      @students = @classroom.students
      @students.each do |student|
        Grade.create(grade: 0, student: student, assignment: @assignment)
        student.save
      end
      @classroom.save
      @teacher = @classroom.teacher
      render json: @classroom, include: '**'
    else
      render json: {error: "Must include a valid description."}
    end
  end

  def students
    @classroom = Classroom.find(params[:id])
    @studentIDs = params[:studentsArr]
    @studentIDs.each do |id|
      @student = Student.find(id)
      Schedule.create(student: @student, classroom: @classroom)
      @classroom.assignments.each do |assignment|
        Grade.create(grade: 0, student: @student, assignment: assignment)
      end
      @classroom.save
    end
    render json: @classroom, include: '**'
  end

end
