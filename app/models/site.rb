# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  abbr       :string(255)
#  pxe        :string(255)
#  storage    :string(255)
#  code       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
end
