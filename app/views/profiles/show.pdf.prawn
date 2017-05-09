prawn_document do |pdf|
  pdf.define_grid(columns: 3, rows: 10)
  pdf.grid(0,0).bounding_box do
    pdf.image "#{Rails.root}/app/assets/images/kw-logo.png", position: :center, scale: 0.18
  end
  pdf.grid(0,1).bounding_box do
    pdf.image "#{Rails.root}/app/assets/images/opp-logo.png", position: :center, scale: 0.1
  end
  pdf.grid(0,2).bounding_box do
    pdf.image "#{Rails.root}/app/assets/images/pza-logo.png", position: :center, scale: 0.2
  end
  pdf.grid([1,0], [1,2]).bounding_box do
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Bold.ttf" do
      pdf.text 'Deklaracja członkowska', align: :center
    end
    pdf.move_down 15
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text 'Proszę o przyjęcie mnie w poczet członków zwyczajnych Klubu Wysokogórskiego Kraków.', align: :left, size: 8
      pdf.move_down 15
      pdf.text "Imię i Nazwisko: #{@profile.first_name} #{@profile.last_name}", align: :left, size: 9
    end
  end
  pdf.grid([2,0], [2,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text "Data i miejsce urodzenia: #{@profile.birth_date}, #{@profile.birth_place}", align: :left, size: 9
      pdf.move_down 5
      pdf.text "Adres zamieszkania: #{@profile.main_address}", align: :left, size: 9
      pdf.move_down 5
      pdf.text "Numer telefonu: #{@profile.phone}", align: :left, size: 9
      pdf.move_down 5
      pdf.text "Adres email: #{@profile.email}", align: :left, size: 9
      pdf.move_down 5
      pdf.text "Pesel: #{@profile.pesel}", align: :left, size: 9
    end
  end
  pdf.grid([3,0], [3,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text "Rodzaj ukończonych kursów:", align: :left, size: 9
      @profile.acomplished_courses.present? && @profile.acomplished_courses.each do |course|
        pdf.move_down 3
        pdf.text "• " + I18n.t("activemodel.attributes.user_management_profile_form.profile_acomplished_courses_#{course}"), size: 8, indent_paragraphs: 10
      end
    end
  end
  pdf.grid([4,0], [4,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text 'Oświadczam, że znam postanowienia Statutu Klubu Wysokogórskiego Kraków i zobowiązuje się do ich przestrzegania. Mając świadomość, że sporty propagowane przez Klub Wysokogórski Kraków mogą być niebezpieczne dla życia lub zdrowia, oświadczam, że uprawianie tych sportów oraz udział w imprezach organizowanych przez Klub podejmuję na własne ryzyko i odpowiedzialność. Równocześnie wyrażam zgodę na przetwarzanie moich danych osobowych dla celów statutowych zgodnie z ustawą z dnia 29 sierpnia 1997r. o ochronie danych osobowych (Dz. U. Nr 133, poz. 883 z 1997 r. z późniejszymi zmianami).', size: 7, indent_paragraphs: 10
    end
  end
  pdf.grid([5,0], [5,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.move_down 3
      pdf.text 'Załączniki:', size: 9
      pdf.move_down 3
      pdf.text "1." + 'Fotografie 3,5 cm x 4,5 cm - 2 szt.', indent_paragraphs: 10, size: 9
      pdf.move_down 3
      pdf.text "2." + 'Świadectwo ukończenia kursu.', indent_paragraphs: 10, size: 9
      pdf.move_down 3
      pdf.text "3." + 'Informacje dodatkowe.', indent_paragraphs: 10, size: 9
    end
  end

  pdf.grid([5,2], [5,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text '.............................................'
      pdf.move_down 3
      pdf.text 'data i czytelny podpis wnioskodawcy*', size: 9
      pdf.text '* w przypadku wysłania deklaracji pocztą e-mail podpis proszę złożyć najpóźniej w dniu odbioru legitymacji.', size: 6
    end
  end
  pdf.grid([6,0], [6,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Bold.ttf" do
      pdf.stroke_horizontal_rule
      pdf.move_down 15
      pdf.text 'Decyzja zarządu', align: :center
    end
    pdf.move_down 15
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text 'Dnia .......................................................... przyjęta/y w poczet członków zwyczajnych Klubu Wysokogórskiego Kraków.'

    end
  end
  pdf.grid([7,0], [7,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text 'Numer legitymacji klubowej ......................'
    end
  end
  pdf.grid(8,0).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text '.............................', align: :center
      pdf.move_down 5
      pdf.text 'za Zarząd', align: :center, size: 9
    end
  end
  pdf.grid(8,2).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text '.............................', align: :center
      pdf.move_down 5
      pdf.text 'Potwierdzam odbiór legitymacji (data, podpis)', align: :center, size: 9
    end
  end
  pdf.grid([10,0], [10,2]).bounding_box do
    pdf.font "#{Rails.root}/app/assets/fonts/Roboto-Regular.ttf" do
      pdf.text 'KRS: 00 000 22 732 REGON: ​001 263 724 NIP​: 676 10 07 059 Statut​: http://www.kw.krakow.pl/statut Bank:​ Millenium nr konta 77 1160 2202 0000 0000 3523 6899', size: 8, align: :center
    end
  end
end
