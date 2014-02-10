# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  file       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Image < ActiveRecord::Base
  has_many :devices
  # has_many :tasks, through: :devices
end
