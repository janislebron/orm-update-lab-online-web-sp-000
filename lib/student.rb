require_relative "../config/environment.rb"

class Student
    attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
        self.update
      else
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name:, grade:)
    student_new = self.new(name, grade)
    student_new.save
    student_new
  end

  def self.new_from_db(row)
     student_new = self.new(row[0], row[1], row[2])
     student_new
   end

   def self.find_by_name(name)

     sql = "SELECT * FROM students WHERE name = ?"

     result = DB[:conn].execute(sql, name)[0]
     self.new_from_db(result)
   end
    

    def update
      sql = "UPDATE students SET name = ?, grade = ?, name = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.name)
    end

end
