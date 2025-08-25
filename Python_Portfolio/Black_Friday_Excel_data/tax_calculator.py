
def tax_calculator(subtotal, tax_rate = 0.06):

  """ this formula calculates overal tax

  Arg:
    subtotal - integer values on which tax_rate should be applied
    tax_rate - float number that represent tax percentage that should be multiplied with subtotal

  Returns:
    tax_calculator
  """
  tax = round(subtotal * tax_rate, 2)
  tax_calculator = subtotal + tax
  return [subtotal, tax, tax_calculator]
