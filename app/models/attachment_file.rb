class AttachmentFile < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader
end
