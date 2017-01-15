
# Temperature Converter

def convert_between_temperature_units(degree, first_unit, second_unit)
  case [first_unit, second_unit]
  when ['C', 'K']
    degree + 273.15
  when ['C', 'F']
    degree * 1.8 + 32
  when ['K', 'C']
    degree - 273.15
  when ['K', 'F']
    ( degree - 273.15 ) * 1.8 + 32
  when ['F', 'C']
    ( degree - 32 ) * Rational(5, 9)
  when ['F', 'K']
    ( degree - 32 ) * Rational(5, 9) + 273.15
  when [first_unit, first_unit]
    degree
  end
end

TABLE_OF_TEMPERATURES = {
  'water' => [0, 100],
  'ethanol' => [-114, 78.37],
  'gold' => [1_064, 2_700],
  'silver' => [961.8, 2_162],
  'copper' => [1_085, 2_567]
}

# Melting Temperature

def melting_point_of_substance(substance_name, unit)
  result = TABLE_OF_TEMPERATURES[substance_name].at(0)
  convert_between_temperature_units(result, 'C', unit)
end

# Boiling Temperature

def boiling_point_of_substance(substance_name, unit)
  result = TABLE_OF_TEMPERATURES[substance_name].at(1)
  convert_between_temperature_units(result, 'C', unit)
end
