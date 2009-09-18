module ContentHelper
  def self.rowstyle(row)
    row.even? ? "even" : "odd"
  end
end
