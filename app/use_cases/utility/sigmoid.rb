class Utility::Sigmoid < Mutations::Command

  required do
    float :k
    float :x
  end

  def execute
    (1 + Math::E**(-1 * inputs[:k] * inputs[:x]))**-1
  end

end