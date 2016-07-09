require "todo/version"
require "thor"

module Todo
  class Base < Thor

    desc :generate, 'generate a task'
    def generate
      puts "generate a task"
    end

    desc :later, 'do later'
    def later
      puts "doing later"
    end


    desc :ing, 'currently doing'
    def ing
      puts "currently doing"
    end

  end
end
