module ScreenSize
  # Rozmiary ekranu(w pikselach)
  @@Width = 600
  @@Height = 480

  # Wielkosc szerokosc i wysokosc pola(w pikselach)
  @@FieldSize = 40

  # Wielkosc poziomow(ilosci pol)
  @@Level_Width = @@Width / @@FieldSize
  @@Level_Height = @@Height / @@FieldSize

  #wielkosc gracza (w pikselach)
  @@PlayerSize = 40
end