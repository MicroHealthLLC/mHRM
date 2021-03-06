class SocioeconomicStatus < Enumeration
  has_many :socioeconomics

  OptionName = :enumeration_socioeconomic_status

  def option_name
    OptionName
  end

  def objects
    Socioeconomic.where(:socioeconomic_status_id => self.id)
  end

  def objects_count
    objects.count
  end

  def transfer_relations(to)
    objects.update_all(:socioeconomic_status_id => to.id)
  end
end