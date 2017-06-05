module TasksHelper
  def render_short_task(task)
    {id: task.id, title: task.title, subject: task.subject, price: task.price,
     estimate: task.estimate, created_at: task.created_at.strftime("%F %T")}
  end

  def render_task_for_all(task)
    { id: task.id, title: task.title, description: task.description,
      subject: task.subject, price: task.price, estimate: task.estimate,
      created_at: task.created_at.strftime("%F %T"), attached: task.attached,
      author: {username: task.username_author, email: task.email_author} }
  end

  def render_task_for_author(task, offered, users)
    task_ = render_task_for_all(task).merge(offered: offered, users: users,
       solution: task.solution)
       if !!(task.username_employee)
         task_.merge!(employee: {username: task.username_employee, email: task.email_employee})
       end
    task_
  end

  def render_task_for_other(task, offered_by_me, assign_to_me)
    render_task_for_all(task).merge(offered_by_me: offered_by_me,
                                    assign_to_me: assign_to_me)
  end

  SELECT_TASK = 'tasks.id, tasks.title, tasks.description, tasks.subject,
    tasks.price, tasks.estimate, tasks.created_at, tasks.attached,
    tasks.user_id, tasks.employee_id, tasks.solution, authors.username AS
    username_author, authors.email AS email_author
    , employees.username AS
    username_employee, employees.email AS email_employee
    '

  def find_task(task_id)
    Task.select(SELECT_TASK).joins('JOIN users AS authors ON tasks.user_id =
          authors.id').joins('LEFT OUTER JOIN users AS employees ON
          tasks.employee_id = employees.id').find_by('tasks.id = ?', task_id)
  end

  def find_my_tasks(author_id, from, order_by, subject, quantity,
                    unscope_fields)
    Task.select(SELECT_TASK).joins('JOIN users AS authors ON tasks.user_id =
          authors.id').joins('LEFT OUTER JOIN users AS employees ON
          tasks.employee_id = employees.id').where(user_id: author_id,
          subject: subject).limit(quantity).offset(from).order(order_by).
          unscope(unscope_fields)
  end

  def find_offerd_by_me_tasks(author_id, from, order_by, subject, quantity,
                              unscope_fields)
    AssignTask.select(SELECT_TASK).joins('JOIN tasks ON tasks.id =
          assign_tasks.task_id').joins('JOIN users AS authors ON tasks.user_id =
          authors.id').
          joins('LEFT OUTER JOIN users AS employees ON
          tasks.employee_id = employees.id').
          where('tasks.subject = ?', subject).
          limit(quantity).offset(from).order("tasks.#{order_by}").unscope(unscope_fields)
  end
end
