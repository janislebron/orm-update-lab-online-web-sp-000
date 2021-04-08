require_relative "../config/environment.rb"

class Student
    attr_accessor :id, :name, :grade

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id=nil)
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

  def self.create
  end


    def self.new_from_db(row)
      # create a new Student object given a row from the database
      student = self.new
      student.id = row[0]
      student.name = row [1]
      student.grade = row[2]
      student
    end


    def self.find_by_name(name)
      # find the student in the database given a name
      sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL
      # return a new instance of the Student class
      DB[:conn].execute(sql, name).map do |row| self.new_from_db(row)
      end.first
    end

    def update
      sql = "UPDATE students SET name = ?, grade = ?, name = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.name)
    end

end
