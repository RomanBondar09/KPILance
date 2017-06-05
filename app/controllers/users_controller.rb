class UsersController < ApplicationController

  def show
    user = User.select(:username, :email, :photo_url, :rating)
               .find_by(username: params[:username])
    if user
      render json: render_user(user), status: :ok
    else
      render json: {error: 'User does not exist'}, status: :bad_request and return
    end
  end

  def create
    user = User.new(user_params)

    if User.find_by(username: params[:username]).nil? && user.save
      user = User.select(:id, :username, :email, :photo_url, :rating)
                 .find_by(username: params[:username])
      log_in(user)
      render json: render_user(user), status: :created
    else
      render json: {error: 'Validation error, try more'}, status: :bad_request and return
    end
  end

  def update
    if !logged_in?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    user = current_user
    user.username = params[:username]
    user.email = params[:email]
    user.photo_url = params[:photo_url]
    if user.save
      render json: render_user(user), status: :ok
    else
      render json: {error: 'Validation error, try more'}, status: :bad_request and return
    end
  end

  def destroy
    if !logged_in?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    current_user.destroy
    render nothing: true, status: :ok
  end

  def tasks
    if !logged_in?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    subject = params[:subject]
    quantity = params[:quantity]
    from = params[:from]
    order_by = params[:order_by]
    unscope_fields = {}
    unscope_fields.merge!(where: :subject) if subject == 'all'
    tasks_for_author = []
    tasks = find_my_tasks(current_user.id, from, order_by, subject, quantity,
                          unscope_fields)
    tasks.each do |task|
      users = AssignTask.joins('JOIN users ON assign_tasks.user_id = users.id').
                         select(:username, :email).where(task_id: task.id)
      offered = !!(users.length != 0)
      tasks_for_author << render_task_for_author(task, offered, users)
    end
    render json: {tasks: tasks_for_author}, status: :ok
  end

  def assigned_tasks
    if !logged_in?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    subject = params[:subject]
    quantity = params[:quantity]
    from = params[:from]
    order_by = params[:order_by]
    unscope_fields = :where if subject == 'all'
    tasks_offerd_by_me = []
    offered_by_me = nil
    users = nil
    tasks = find_offerd_by_me_tasks(current_user.id, from, order_by, subject,
                                    quantity, unscope_fields)
    puts tasks.to_json
    tasks.select do |task|
      users = AssignTask.joins('JOIN users ON
                                assign_tasks.user_id = users.id').
                         select(:username, :email).where(task_id: task.id)
      offered_by_me = !!users.find_index do |user|
        user.username == current_user.username
      end
    end
    tasks.each do |task|
      assing_to_me = true if task.employee_id == current_user.id
      respond_task = render_task_for_other(task, offered_by_me, assing_to_me)
      tasks_offerd_by_me << render_task_for_other(task, true,
                                                  assing_to_me)
    end
    render json: {tasks: tasks_offerd_by_me}, status: :ok
  end

  def assign
    task = Task.find_by(id: params[:id])
    user = current_user
    if task && user && task.user_id != user.id
      AssignTask.create(task_id: task.id, user_id: user.id)
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bad_request and return
    end
  end

  def unassign
    task = Task.find_by(id: params[:id])
    user = current_user
    if task && user && (task.user_id != user.id)
      task_assign = AssignTask.where(task_id: task.id, user_id: user.id)
      if !!task_assign
        AssignTask.destroy(task_assign.ids)
      end
      if task.employee_id == user.id
        task.employee_id = nil
        task.save
      end
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bad_request and return
    end
  end

  def author_assign
    task = Task.find_by(id: params[:id])
    if task && current_user.id == task.user_id
      users = AssignTask.joins('JOIN users ON assign_tasks.user_id = users.id').
                         select('users.id, users.username, users.email').
                         where(task_id: task.id)
      employee = users.find_index do |user|
        user.username == params[:username]
      end
      if employee.nil?
        render json: {error: 'error'}, status: :bad_request and return
      end
      puts employee.to_json
      task.employee_id = users[employee].id
      task.save
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bad_request and return
    end
  end

  def author_unassign
    task = Task.find_by(id: params[:id])
    if task && (current_user.id == task.user_id)
      if !task.employee_id
        render json: {error: 'error1'}, status: :bad_request and return
      end
      task.update(employee_id: nil)
    else
      render json: {error: 'error2'}, status: :bad_request and return
    end
  end

  def increase
    puts current_user.to_json
    if current_user.nil?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    user = User.find_by(username: params[:username])
    if user.nil?
      render json: {error: 'error'}, status: :bad_request and return
    end

    entry = UserRating.find_by(user_sender_id: current_user.id,
                               user_recipient_id: user.id)
    if entry
      if entry.rating == -1
        entry.rating = 1
        entry.save
        user.rating += 2
      end
    else
      UserRating.create(user_sender_id: current_user.id,
                        user_recipient_id: user.id, rating: 1)
      user.rating += 1
    end
    user.save
    render json: {rating: user.rating}, status: :ok
  end

  def decrease
    puts current_user.to_json
    if current_user.nil?
      render json: {error: 'Authenticate error'}, status: :bad_request and return
    end
    user = User.find_by(username: params[:username])
    if !user
      render json: {error: 'error'}, status: :bad_request and return
    end
    entry = UserRating.find_by(user_sender_id: current_user.id,
                               user_recipient_id: user.id)
    if entry
      if entry.rating == 1
        entry.rating = -1
        entry.save
        user.rating -= 2
      end
    else
      UserRating.create(user_sender_id: current_user.id,
                        user_recipient_id: user.id, rating: -1)
      user.rating -= 1
    end
    user.save
    render json: {rating: user.rating}, status: :ok
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
