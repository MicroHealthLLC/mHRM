prawn_document(:page_layout => :portrait) do |pdf|
   User.current.to_pdf_organization(pdf)
    User.current.to_pdf( pdf)
    pdf.move_down 10
    render 'extend_demographies/show', :pdf=> pdf, extend_information: User.current.extend_informations
   if @languages.any?
     pdf.start_new_page
     @languages.each do |object|
       object.to_pdf(pdf, false)
       pdf.move_down 20
     end
   end
   pdf.start_new_page
   if @affiliations.any?
     @affiliations.each do |object|
      object.to_pdf(pdf, false)
      pdf.move_down 20
    end
   end
   if @contacts.any?
     pdf.start_new_page
     @contacts.each do |object|
      object.to_pdf(pdf, false)
      pdf.move_down 20
     end
   end
   if @user_insurances.any?
     pdf.start_new_page
     @user_insurances.each do |object|
      object.to_pdf(pdf, false)
      pdf.move_down 20
    end
   end
   if @documents.any?
     pdf.start_new_page
     @documents.each do |object|
      object.to_pdf(pdf, false)
      pdf.move_down 20
    end
   end

     pdf.start_new_page  if @jsignatures.any?
       @jsignatures.each do |object|
          object.to_pdf(pdf, "Release of Information")
          pdf.move_down 20
        end

end