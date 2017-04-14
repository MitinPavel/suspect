module Suspect
  module FileUtils
    class FlockWriter

      PERMISSIONS = 0644
      MODE = 'a'

      def write(path, content)
        File.open path, MODE, PERMISSIONS do |f|
          f.flock File::LOCK_EX
          f.write "#{content}\n"
          f.flush
        end
      end
    end
  end
end
