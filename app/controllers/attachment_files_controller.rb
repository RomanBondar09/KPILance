class AttachmentFilesController < ApplicationController

  def upload_description
    attach_file = AttachmentFile.new(name: params[:id],task_id: params[:id], attachment: params[:file])
    if attach_file.save
      task = Task.find_by(id: params[:id])
      task.attached = true
      task.save
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bed_request and return
    end
  end

  def download_description
    file = AttachmentFile.find_by(task_id: params[:id])
    puts file.to_json
    if file
      #send_file('public/uploads/attachment_file/attachment/1/_____________________3.docx')
      send_file("#{RAILS_ROOT}/public" + file.attachment.url)
    else
      render json: {error: 'File does not exist'}, status: :bad_request
    end
  end

  def upload_solution
    file = AttachmentFile.new(task_id: params[:id], attachment: params[:file])
    if file.save
      render nothing: true, status: :ok
    else
      render json: {error: 'error'}, status: :bed_request and return
    end
  end

  # def download_description
  #   file = Task.select('attachment_files.attachment').joins('LEFT OUTER JOIN attachment_files ON
  #           attachment_files.task_id = tasks.id').where("tasks.id = #{params[:id]}")
  #   if file
  #     send_file(file.attachment_url)
  #   else
  #     render json: {error: 'File does not exist'}, status: :bad_request
  #   end
  # end
end
