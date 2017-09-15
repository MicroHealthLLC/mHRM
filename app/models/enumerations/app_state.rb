class AppState < Enumeration
  has_many :job_apps

  OptionName = :enumeration_app_state

  def option_name
    OptionName
  end

  def objects
    JobApp.where(:app_state_id => self.id)
  end

  def objects_count
    objects.count
  end

  def transfer_relations(to)
    objects.update_all(:app_state_id => to.id)
  end
end