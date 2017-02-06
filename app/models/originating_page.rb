class OriginatingPage
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def title
    path.gsub('/', '').titleize
  end
end
