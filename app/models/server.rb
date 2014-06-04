class Server < ActiveRecord::Base
  belongs_to :site
  enum role: { storage: 0, pxe: 1 }
end
