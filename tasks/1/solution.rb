
# Temperature Converter
TEMPERATURE_CONVERTING_NUMBERS = {
  number1: 273.15,
  number2: 1.8,
  number3: 32,
  number4: 5.0 / 9,
}

def convert_between_temperature_units(degree, first_unit, second_unit)

  case [first_unit, second_unit]
  when ['C', 'K']
    degree + TEMPERATURE_CONVERTING_NUMBERS[:number1]
  when ['C', 'F']
    degree * TEMPERATURE_CONVERTING_NUMBERS[:number2] +
    TEMPERATURE_CONVERTING_NUMBERS[:number3]
  when ['K', 'C']
    degree - TEMPERATURE_CONVERTING_NUMBERS[:number1]
  when ['K', 'F']
    ( degree - TEMPERATURE_CONVERTING_NUMBERS[:number1] ) *
    TEMPERATURE_CONVERTING_NUMBERS[:number2] +
    TEMPERATURE_CONVERTING_NUMBERS[:number3]
  when ['F', 'C']
    ( degree - TEMPERATURE_CONVERTING_NUMBERS[:number3] ) *
    TEMPERATURE_CONVERTING_NUMBERS[:number4]
  when ['F', 'K']
    ( degree - TEMPERATURE_CONVERTING_NUMBERS[:number3] ) *
    TEMPERATURE_CONVERTING_NUMBERS[:number4] +
    TEMPERATURE_CONVERTING_NUMBERS[:number1]
  when [first_unit, first_unit]
    degree
  end
end

TABLE_OF_TEMPERATURES = {
  'water'   => {melting_point: 0,     boiling_point: 100  },
  'ethanol' => {melting_point: -114,  boiling_point: 78.37},
  'gold'    => {melting_point: 1_064, boiling_point: 2_700},
  'silver'  => {melting_point: 961.8, boiling_point: 2_162},
  'copper'  => {melting_point: 1_085, boiling_point: 2_567},
}

# Melting Temperature

def melting_point_of_substance(substance_name, unit)
  result = TABLE_OF_TEMPERATURES[substance_name][:melting_point]
  convert_between_temperature_units(result, 'C', unit)
end

# Boiling Temperature

def boiling_point_of_substance(substance_name, unit)
  result = TABLE_OF_TEMPERATURES[substance_name][:boiling_point]
  convert_between_temperature_units(result, 'C', unit)
end
