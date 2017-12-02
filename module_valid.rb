module Valid
  def valid?
    validate1!
    true
  rescue
    false
  end
end
