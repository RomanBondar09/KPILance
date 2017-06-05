Rails.application.routes.draw do
  get    '/user/:username',         to: 'users#show'             #done
  post   '/user',                   to: 'users#create'           #done
  put    '/user',                   to: 'users#update'           #done
  delete '/user',                   to: 'users#destroy'          #done
  post   '/login',                  to: 'logins#create'          #done
  delete '/logout',                 to: 'logins#destroy'         #done
  get    '/task/:id',               to: 'tasks#show'             #done
  get    '/task',                   to: 'tasks#index'            #done
  post   '/task',                   to: 'tasks#create'           #done
  put    '/task/:id',               to: 'tasks#update'           #done
  delete '/task/:id',               to: 'tasks#destroy'          #done
  get    '/usertask',               to: 'users#tasks'            #done
  get    '/usertask/assign',        to: 'users#assigned_tasks'   #done
  put    '/task/:id/assign',        to: 'users#assign'           #done
  put    '/task/:id/unassign',      to: 'users#unassign'         #done
  put    '/user/task/:id/assign',   to: 'users#author_assign'    #done
  put    '/user/task/:id/unassign', to: 'users#author_unassign'  #done
  put    '/user/task/:id/done',     to: 'users#done'
  post   '/:username/increase',     to: 'users#increase'         #done
  post   '/:username/decrease',     to: 'users#decrease'         #done
  post   '/task/:id/description',   to: 'attachment_files#upload_description'
  get    '/task/:id/description',   to: 'attachment_files#download_description'
  post   '/task/:id/solution',      to: 'attachment_files#destroy'
end

# CarrierWaveExample::Application.routes.draw do
#   post   'attachment_files',       to: 'attachment_files#create'
#   delete 'attachment_files',       to: 'attachment_files#destroy'
# end
