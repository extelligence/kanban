class Task < ActiveRecord::Base
  validates :content,  :presence => true
  validates :status,   :presence => true
  validates :priority, :presence => true
  validates :owner,    :presence => true
end

# == Schema Information
#
# Table name: tasks
#
#  id         :integer         not null, primary key
#  content    :text
#  status     :string(255)
#  priority   :integer
#  owner      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
