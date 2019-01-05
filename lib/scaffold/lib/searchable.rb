module Searchable
  
  def where(params)
    relation = Relation.new(table_name: self.table_name)
    relation.where(params)
  end

  def joins(table_name)
    relation = Relation.new(table_name: self.table_name)
    relation.joins(table_name)
  end

  def left_joins(table_name)
    relation = Relation.new(table_name: self.table_name)
    relation.left_joins(table_name)
  end

  def select(*params)
    relation = Relation.new(table_name: self.table_name)
    relation.select(*params)
  end

  def find_by(params)
    arr = where(params)
    arr.empty? ? nil : arr.first
  end
end