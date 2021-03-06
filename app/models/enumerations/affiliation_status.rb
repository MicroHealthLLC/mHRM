class AffiliationStatus < Enumeration
  has_many :affiliations

  OptionName = :enumeration_affiliation_status

  def option_name
    OptionName
  end

  def objects
    Affiliation.where(:status_id => self.id)
  end

  def objects_count
    objects.count
  end

  def transfer_relations(to)
    objects.update_all(:status_id => to.id)
  end
end