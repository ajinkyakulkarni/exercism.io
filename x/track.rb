module X
  # Essentially a wrapper around the /tracks resource from the exercises API.
  class Track
    def self.all
      _, body = X::Xapi.get('tracks')
      JSON.parse(body)['tracks'].map do |row|
        new(row)
      end
    end

    def self.find(id)
      _, body = X::Xapi.get('tracks', id)
      new(JSON.parse(body)['track'])
    end

    METHODS = [
      :id, :language, :repository,
      :todo, :problems, :docs, :doc_format,
      :active, :implemented, :checklist_issue
    ].freeze
    attr_reader(*METHODS)

    alias active?      active
    alias implemented? implemented
    alias slug         id

    def initialize(data)
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", data[name.to_s])
      end
      @problems = data['problems'].map { |row| Problem.new(row) }
      @docs = Docs::Track.new(data['docs'], repository, doc_format)
    end

    def unimplemented_problems
      X::Todo.track(id)
    end

    def fetch_cmd(problem=problems.first)
      "exercism fetch #{id} #{problem}"
    end

    def planned?
      !implemented
    end
  end
end
