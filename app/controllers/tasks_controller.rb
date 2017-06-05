class TasksController < ApplicationController

  def show
    task = find_task(params[:id])
    if !task
      render json: {error: 'Task does not exist'}, status: :bad_request and return
    end
    users = AssignTask.joins('JOIN users ON assign_tasks.user_id = users.id').
                       select(:username, :email).where(task_id: task.id)
    if !logged_in?
      respond_task = render_short_task(task)
    elsif task.user_id == current_user.id
      offered = !!(users.length != 0)
      respond_task = render_task_for_author(task, offered, users)
    else
      offered_by_me = !!users.find_index do |user|
        user.username == current_user.username
      end
      assing_to_me = true if task.employee_id == current_user.id
      respond_task = render_task_for_other(task, offered_by_me, assing_to_me)
    end
    render json: respond_task, status: :ok
  end

  def create
    if !logged_in?
      render json: {error: 'Authenticate error'}, status: :bad_request
      return
    end
    puts current_user.id
    task = Task.new(
    title: params[:title], price: params[:price], subject: params[:subject],
    description: params[:description], user_id: current_user.id
    #task_params.merge(user_id: current_user.id
    )
    task.user_id = current_user.id
    puts task.to_json
    if task.save
      puts task.to_json
      task = find_task(task.id)
      puts task.to_json
      task = render_task_for_author(task, false, [])
      render json: task, status: :ok
    else
      render json: {error: 'Validation error, try more'}, status: :bad_request and return
    end
  end

  def index
    subject = params[:subject]
    quantity = params[:quantity]
    from = params[:from]
    order_by = params[:order_by]
    unscope_fields = []
    unscope_fields << {where: :subject} if subject == 'all'
    short_tasks = []
    tasks = Task.select('tasks.id, tasks.title, tasks.subject, tasks.price,
            tasks.estimate, tasks.created_at').where(subject: subject).
            limit(quantity).offset(from).order(order_by).unscope(unscope_fields)
    if tasks.length == 0
      render nothing: true, status: :bad_request and return
    end
    tasks.each do |task|
      short_tasks << render_short_task(task)
    end
    render json: {tasks: short_tasks}, status: :ok
  end

  def update
    task = Task.find_by(id: params[:id])
    if current_user.id = task.user_id
      if task.update(title: params[:title], description: params[:description],
                  subject: params[:subject], price: params[:price],
                  estimate: params[:estimate])
         render json: task, status: :ok
      else
        render json: {error: 'Validation error, try more'}, status: :bad_request and return
      end
    else
      render json: {error: 'error'}, status: :bad_request and return
    end
  end

  def destroy
    task = Task.find_by(id: params[:id])
    if current_user.id = task.user_id
      task.destroy
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bad_request and return
    end
  end

  private

  def task_params
    params.permit(:title, :description, :subject, :price, :estimate)
  end
end
