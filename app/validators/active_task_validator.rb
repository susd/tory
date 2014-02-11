class ActiveTaskValidator < ActiveModel::Validator
  def validate(record)
    klass = record.class
    hit = klass.where(device_id: record.device_id, state: 'active').where('id != ?', record.id).any?
    if hit
      record.errors.add :base, "Active task already exists"
    end
  end
end